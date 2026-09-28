#!/usr/bin/env node
/*
 * The image half of the asset factory. One entry point, four jobs.
 *
 *   node pipeline/assets.js cutout  <in> <out.png> [threshold] [x0,y0,x1,y1]
 *   node pipeline/assets.js webp    <in...> --out <dir> [--width 1000] [--quality 84]
 *   node pipeline/assets.js sheet   <out.png> <cols> <cell> <in...>   [--bg '#f4f4f2']
 *   node pipeline/assets.js favicon <in> <outDir>
 *
 * cutout  removes a white studio ground from a generated mark, feathers the edge so
 *         jpeg fringing does not read as a halo, trims and sizes it.
 * webp    converts and resizes for the web, and prints the saving, because the report
 *         needs numbers rather than adjectives.
 * sheet   builds a contact sheet so a whole set can be judged in one look.
 * favicon exports the standard icon sizes.
 *
 * Every one of these was extracted from work that shipped. The thresholds and the
 * reasoning behind them are in taste-frontend/references/asset-generation.md.
 */
const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const KB = n => Math.round(n / 1024) + ' KB';
const base = f => f.split(/[\\/]/).pop();

function argValue(args, flag, fallback) {
  const i = args.indexOf(flag);
  return i > -1 && args[i + 1] !== undefined ? args[i + 1] : fallback;
}
function positional(args) {
  const out = [];
  for (let i = 0; i < args.length; i++) {
    if (args[i].startsWith('--')) { i++; continue; }
    out.push(args[i]);
  }
  return out;
}

/* ------------------------------------------------------------------ */
async function cutout(input, output, thrS, eraseS) {
  const T = +(thrS || 240);
  const { data, info } = await sharp(input).ensureAlpha().raw().toBuffer({ resolveWithObject: true });
  const W = info.width, H = info.height;

  // a generator signature is not part of the mark, so drop it before the flood
  if (eraseS) {
    const [x0, y0, x1, y1] = eraseS.split(',').map(Number);
    for (let y = y0; y < y1; y++) for (let x = x0; x < x1; x++) {
      const i = (y * W + x) * 4; data[i] = data[i + 1] = data[i + 2] = 255;
    }
  }

  const lum = i => (data[i * 4] * 299 + data[i * 4 + 1] * 587 + data[i * 4 + 2] * 114) / 1000;

  // flood from the border inward, so white enclosed by the artwork survives.
  // a pop art burst is a white shape with a black outline: cutting it would destroy the mark.
  const bg = new Uint8Array(W * H);
  const stack = [];
  const push = (x, y) => { const i = y * W + x; if (!bg[i] && lum(i) > T) { bg[i] = 1; stack.push(i); } };
  for (let x = 0; x < W; x++) { push(x, 0); push(x, H - 1); }
  for (let y = 0; y < H; y++) { push(0, y); push(W - 1, y); }
  while (stack.length) {
    const i = stack.pop(), x = i % W, y = (i / W) | 0;
    if (x > 0) push(x - 1, y); if (x < W - 1) push(x + 1, y);
    if (y > 0) push(x, y - 1); if (y < H - 1) push(x, y + 1);
  }

  let cut = 0;
  for (let i = 0; i < W * H; i++) if (bg[i]) { data[i * 4 + 3] = 0; cut++; }

  // feather by darkness, so jpeg fringing does not become a halo on the page ground
  for (let i = 0; i < W * H; i++) {
    if (bg[i]) continue;
    const x = i % W, y = (i / W) | 0;
    const edge = (x > 0 && bg[i - 1]) || (x < W - 1 && bg[i + 1]) || (y > 0 && bg[i - W]) || (y < H - 1 && bg[i + W]);
    if (edge) data[i * 4 + 3] = Math.max(0, Math.min(255, Math.round((255 - lum(i)) * 1.7)));
  }

  const png = await sharp(data, { raw: { width: W, height: H, channels: 4 } }).png().toBuffer();
  const trimmed = await sharp(png).trim({ threshold: 1 }).toBuffer();
  await sharp(trimmed).resize({ width: 1100, withoutEnlargement: true }).png({ compressionLevel: 9 }).toFile(output);
  const m = await sharp(output).metadata();
  console.log(`${base(output)}  ${m.width}x${m.height}  ground removed ${Math.round(100 * cut / (W * H))}%`);
  console.log('Open it on the real page ground before keeping it. White pockets the flood');
  console.log('cannot reach stay white: repaint them to the ground colour rather than cutting.');
}

/* ------------------------------------------------------------------ */
async function webp(inputs, outDir, width, quality) {
  fs.mkdirSync(outDir, { recursive: true });
  let before = 0, after = 0;
  for (const f of inputs) {
    const out = path.join(outDir, base(f).replace(/\.[^.]+$/, '') + '.webp');
    await sharp(f).resize({ width: +width, withoutEnlargement: true })
      .webp({ quality: +quality, alphaQuality: 90, effort: 6 }).toFile(out);
    const a = fs.statSync(f).size, b = fs.statSync(out).size;
    before += a; after += b;
    console.log(`   ${base(out).padEnd(26)} ${KB(a).padStart(9)} -> ${KB(b)}`);
  }
  const saved = before ? Math.round(100 * (before - after) / before) : 0;
  console.log(`   total ${KB(before)} -> ${KB(after)}, ${saved}% smaller across ${inputs.length} file(s)`);
}

/* ------------------------------------------------------------------ */
async function sheet(output, cols, cell, inputs, bg) {
  const rows = Math.ceil(inputs.length / cols);
  const comp = [];
  for (let i = 0; i < inputs.length; i++) {
    const buf = await sharp(inputs[i])
      .resize(+cell, +cell, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
      .png().toBuffer();
    comp.push({ input: buf, left: (i % cols) * cell, top: Math.floor(i / cols) * cell });
  }
  await sharp({ create: { width: cols * cell, height: rows * cell, channels: 3, background: bg } })
    .composite(comp).png().toFile(output);
  console.log(`${base(output)}  ${inputs.length} frames on ${bg}`);
  console.log('Composite on the real page ground, not on white. A halo is invisible on white.');
}

/* ------------------------------------------------------------------ */
async function favicon(input, outDir) {
  fs.mkdirSync(outDir, { recursive: true });
  for (const s of [16, 32, 48, 180, 512]) {
    const name = s === 180 ? 'apple-touch-icon.png' : `favicon-${s}.png`;
    await sharp(input).resize(s, s, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
      .png({ compressionLevel: 9 }).toFile(path.join(outDir, name));
    console.log(`   ${name}`);
  }
}

/* ------------------------------------------------------------------ */
(async () => {
  const [cmd, ...args] = process.argv.slice(2);
  const pos = positional(args);
  try {
    if (cmd === 'cutout') await cutout(pos[0], pos[1], pos[2], pos[3]);
    else if (cmd === 'webp') await webp(pos, argValue(args, '--out', 'out'), argValue(args, '--width', 1000), argValue(args, '--quality', 84));
    else if (cmd === 'sheet') await sheet(pos[0], +pos[1], +pos[2], pos.slice(3), argValue(args, '--bg', '#f4f4f2'));
    else if (cmd === 'favicon') await favicon(pos[0], pos[1]);
    else {
      console.log(fs.readFileSync(__filename, 'utf8').split('*/')[0].split('/*')[1].trim());
      process.exit(1);
    }
  } catch (e) { console.error('FAILED: ' + e.message); process.exit(1); }
})();
