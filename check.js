#!/usr/bin/env node
// The whole CI for this repository: run it before every commit.
//   node check.js
// It is deliberately dependency free, so an agent can run it in any checkout.
const fs = require('fs');
const path = require('path');

const ROOT = __dirname;
const SEP = String.fromCharCode(92); // backslash, without writing one

// documents the pipeline creates at run time, so a reference to them is not a broken link
const RUNTIME = new Set(['BRAND.md', 'INTAKE.md', 'AUDIT.md', 'CONTRACT.md', 'REVIEW_SUMMARY.md',
  'HANDOFF.md', 'CHECKLIST.md', 'site-plan.md', 'prompts.md', 'prompt.md', 'MOTION.md',
  'README.md', 'CONTRIBUTING.md', 'DESIGN.md']);

const files = [];
(function walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (e.name === '.git' || e.name === 'node_modules') continue;
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p);
    else if (e.name.endsWith('.md')) files.push(p);
  }
})(ROOT);

const rel = f => path.relative(ROOT, f).split(SEP).join('/');
const names = new Set(files.map(f => path.basename(f)));
let failures = 0;

// 1. no em or en dash. the underlying ruleset bans them and shipped files have failed this.
console.log('1. dashes');
let dashes = 0;
for (const f of files) {
  fs.readFileSync(f, 'utf8').split('\n').forEach((line, i) => {
    if (/[—–]/.test(line)) { console.log('   ' + rel(f) + ':' + (i + 1)); dashes++; }
  });
}
console.log(dashes ? '   FAIL: ' + dashes + ' line(s)' : '   ok');
if (dashes) failures++;

// 2. every cross reference resolves. the files point at each other by bare filename.
console.log('2. cross references');
let unresolved = 0;
for (const f of files) {
  fs.readFileSync(f, 'utf8').split('\n').forEach((line, i) => {
    for (const m of line.matchAll(/[\w.-]+\.md\b/g)) {
      const base = path.basename(m[0]);
      if (RUNTIME.has(base) || names.has(base)) continue;
      console.log('   ' + rel(f) + ':' + (i + 1) + '  ' + m[0]);
      unresolved++;
    }
  });
}
console.log(unresolved ? '   FAIL: ' + unresolved + ' unresolved' : '   ok');
if (unresolved) failures++;

// 3. skills these files delegate to. delegating to one that is not installed fails silently.
console.log('3. delegated skills');
const known = ['design-taste-frontend', 'redesign-existing-projects', 'animate', 'brandkit',
  'high-end-visual-design', 'emil-design-eng'];
const found = new Set();
for (const f of files) {
  const body = fs.readFileSync(f, 'utf8');
  for (const k of known) if (body.includes('`' + k + '`')) found.add(k);
}
if (found.size) { for (const k of [...found].sort()) console.log('   ' + k); }
else console.log('   none');
console.log('   confirm each is installed before relying on it');

// 4. every skill folder has its SKILL.md with front matter.
// a folder counts as a skill when it holds a SKILL.md or a references/ directory,
// so infrastructure folders like pipeline/ and playbooks/ are not mistaken for one.
console.log('4. skill front matter');
let broken = 0;
for (const d of fs.readdirSync(ROOT, { withFileTypes: true })) {
  if (!d.isDirectory() || d.name.startsWith('.') || d.name === 'node_modules') continue;
  const dir = path.join(ROOT, d.name);
  const skill = path.join(dir, 'SKILL.md');
  const looksLikeSkill = fs.existsSync(skill) || fs.existsSync(path.join(dir, 'references'));
  if (!looksLikeSkill) continue;
  if (!fs.existsSync(skill)) { console.log('   ' + d.name + ': has references/ but no SKILL.md'); broken++; continue; }
  const head = fs.readFileSync(skill, 'utf8').slice(0, 2000);
  if (!/^---[\s\S]*?\bname:\s*\S/.test(head) || !/\bdescription:\s*\S/.test(head)) {
    console.log('   ' + d.name + ': SKILL.md front matter missing name or description'); broken++;
  } else console.log('   ' + d.name + ': ok');
}
console.log(broken ? '   FAIL: ' + broken : '   ok');
if (broken) failures++;

console.log('');
console.log(failures ? 'FAIL' : 'PASS');
process.exit(failures ? 1 : 0);
