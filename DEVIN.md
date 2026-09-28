# Devin, read this first

You are working on the production tooling of TASTE, a rebranding studio for AI products. This repository holds two Claude Code skills and the executable pipeline behind them.

You cannot run a Claude Code skill. You do not need to. The skills are markdown specifications, and everything mechanical in them has a script in `pipeline/`. Read the specification, run the script, report numbers.

## The division of labour, which is not negotiable

A person and Claude Code do the parts that need taste: intake, brand strategy, the motif, art direction, and choosing which generated image to keep. Those decisions are the product this studio sells.

You do the parts that need hands and patience: rendering, converting, auditing a repository, verifying a build, keeping this repository honest.

**If a task asks you to decide how something should look, stop and say so.** Generic output is precisely what this studio sells against, so an agent-authored visual direction is worse than none.

## What good work looks like here

- **Numbers, not adjectives.** "Lighter" is not a result. "576KB as WebP against 6.3MB as PNG, 36 frames at 720px" is.
- **Run it before you write it.** Two code skeletons in this repository contradicted the warnings printed directly above them, because nobody executed them. If you add or change a code block, execute it and paste real output.
- **Say what you did not verify.** A report that hides a gap is worse than a short one.
- **One pull request per task.** Narrow scope, clear definition of done.

## Before every pull request

```
node check.js
```

Dependency free, runs anywhere. It enforces the dash ban, resolves every cross reference, lists delegated skills and validates skill front matter. It must print PASS.

## The rules you must not violate

These come from `taste-frontend/references/PREFERENCES.md`, which records what this studio's client accepted and refused out loud. That file outranks every other default in this repository. `knowledge/devin-rules.md` is the same content compressed into short imperatives, suitable for pasting into your knowledge base.

The short version:

- No em dashes or en dashes, anywhere, ever.
- Identity artwork is generated or rendered, never hand authored as SVG path coordinates.
- Every generated image is looked at before it is kept. If you cannot look at it, say so rather than keeping it.
- Never delegate to a skill that is not installed. It fails silently.
- Never add a second route to a result the repository already documents. Those routes were tried and refused.

## Where things are

```
taste-rebrand/      the engagement pipeline, phase by phase
taste-frontend/     the craft library it draws on
pipeline/           executable tools: Blender rendering, image processing
playbooks/          task templates. start here for a standing job
knowledge/          the rules, compressed for your knowledge base
check.js            the whole CI
```

## Standing jobs

Each has a playbook. Read the playbook, not this summary.

| job | playbook | trigger |
|---|---|---|
| Render a 3D object and its turntable | `playbooks/asset-factory.md` | a scene script lands in a client repo |
| Audit a prospect's repository | `playbooks/audit.md` | a repository URL arrives |
| Verify a finished build | `playbooks/review-gate.md` | a site is ready for the review gate |
| Keep this repository honest | `playbooks/review-skill.md` | monthly, or after a run of edits |
