# TASTE skills

The production tooling of TASTE, a rebranding studio for AI products. Two Claude Code skills that take a product from a description or a generic repo to a finished brand and a site.

This repository is the source of truth. The installed skills are junctions pointing here, so an edit committed here is live in the next session.

## The two skills

**`taste-rebrand`** is the engagement pipeline. Intake, audit, brand strategy, the deliverable `brand/` folder, the site, a mandatory review gate, delivery. It runs in one of two modes, decided at intake:

- **greenfield**, a product or service description and no code, site built new
- **rebrand**, an existing repo, rebuilt with the backend preserved behind a locked contract

**`taste-frontend`** is the craft library the pipeline draws on. It wraps `design-taste-frontend` (the anti-slop v2 ruleset) and adds the three things that ruleset structurally cannot know: what this client has accepted and refused out loud, how the reference corpus is actually built, and how to produce assets rather than fake them.

It also stands alone for a single page that needs the house standard without the full pipeline.

## Read order

Every engagement, in this order:

1. `taste-frontend/references/PREFERENCES.md`, the client taste law. It outranks every default. Everything in it was earned on rejected work, with the reactions quoted.
2. `taste-frontend/references/reference-corpus.md`, the sites held as the standard, torn down technically.
3. `taste-rebrand/SKILL.md`, which names the exact reference file to read at each phase.

## The rules that matter most

- **Identity artwork is generated or built, never hand-authored.** Marks and imagery go to an image model. Objects go to Blender, which is allowed where hand-drawn SVG is banned because rendering gives a real feedback loop: render, open the image, look, adjust.
- **Substance before frame.** The reference sites carry between twelve and five hundred assets each. A beautiful frame around nothing is still nothing. The floor is eight distinct real assets on a brand page, counted.
- **One interactive moment**, performing the product's actual claim, and one scroll-scrubbed set piece. Everything else on the free motion tiers.
- **The `brand/` folder is finished before the site starts.** A site built while its assets are still being invented becomes motion polish on nothing.
- **Nothing ships past the review gate without explicit approval.**

## Layout

```
taste-rebrand/
  SKILL.md                      the pipeline, phase by phase
  references/
    intake-brief.md             the eight questions, including the subject question
    audit-patterns.md           the generic-AI pattern catalogue
    contract-extraction.md      how to lock a backend before rebuilding its frontend
    brand-strategy-template.md  positioning, tone, narrative, motif, register
    brand-folder.md             what the deliverable folder contains and how it is produced
    design-system-tokens.md     colour, type, spacing and motion as files
    performance-budget.md       the numbers a premium site still has to hit
    review-checkpoint.md        the verification pass and the gate
    delivery-brand-guidelines.md
    master-checklist.md         copy this to taste/CHECKLIST.md and tick it live

taste-frontend/
  SKILL.md                      the overlay, and the pre-flight
  references/
    PREFERENCES.md              the client taste law
    reference-corpus.md         seven sites torn down
    subject-matter.md           what the page is actually about, and the asset floor
    asset-generation.md         image routes, prompts, model biases, compositing
    blender-pipeline.md         headless 3D, the four traps, the turntable
    site-composition.md         turning a brand folder into a page
    cinematic-scroll.md         the motion ladder, and how to stay smooth
    interactivity.md            the one thing the visitor can do
    visual-registers.md
  assets/                       accepted generated assets, kept as reference
```

## For an autonomous agent

Devin, or any agent working on this repository, reads `DEVIN.md` first. It sets the division of labour, which is not negotiable: a person decides how things look, an agent runs the machine.

`playbooks/` holds the standing jobs, one file each: the asset factory, a prospect audit, the review gate, and keeping this repository honest. `pipeline/` holds what they execute, Blender rendering and image processing. `knowledge/devin-rules.md` is the rule set compressed for a knowledge base.

Nothing in `pipeline/` has been run on a Linux machine yet. The first task to use it reports what actually happened, and the scripts get corrected from that report.

## Install

The skills live here and are linked into Claude Code's skill folder. On Windows, from an elevated prompt or with Developer Mode on:

```
cmd /c mklink /J "%USERPROFILE%\.claude\skills\taste-rebrand"  "<repo>\taste-rebrand"
cmd /c mklink /J "%USERPROFILE%\.claude\skills\taste-frontend" "<repo>\taste-frontend"
```

On macOS or Linux:

```
ln -s "<repo>/taste-rebrand"  ~/.claude/skills/taste-rebrand
ln -s "<repo>/taste-frontend" ~/.claude/skills/taste-frontend
```

**Check the link, not the folder.** A stale real copy in `.claude/skills` silently shadows the repo and every edit here is ignored. It has happened twice. On Windows, `dir %USERPROFILE%\.claude\skills` must show `<JUNCTION>` next to both names, never `<DIR>`.

`taste-frontend` assumes `design-taste-frontend` is installed alongside it.

## House rules for anyone editing these files

- No em dashes or en dashes anywhere. The underlying ruleset bans them and the files are checked.
- Every rule states the failure that produced it. A rule with no evidence behind it is a preference, and preferences belong in `PREFERENCES.md` with a quote.
- Code in these files is copied straight into production, so it must be code that has actually run. Two of the skeletons here were wrong for months because nobody executed them.
- Cross-references are by filename. Check they resolve before committing.
