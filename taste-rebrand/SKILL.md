---
name: taste-rebrand
description: TASTE agency's end-to-end engagement pipeline. From a product or service description, with or without an existing codebase, it builds a complete brand (positioning, storytelling, a generated identity mark, a coherent imagery set, colour and type tokens, and 3D objects via Blender where the brief warrants them) into a deliverable brand/ folder, then composes a responsive, interactive, cinematic website from that folder to the standard of the client's reference corpus. Use it whenever the user starts a TASTE client project, says "build a brand for this", "rebrand this SaaS", "give this product an identity and a site", hands over a product description or a repo, or asks for the brand folder, the logo, the assets or the site for a client. Two modes, detected at intake: greenfield (description only) and rebrand (existing repo, backend preserved). Do not use for a one-off page with no brand work; use taste-frontend directly for that.
---

# TASTE engagement pipeline

## What comes out

Two things, in this order, because the second is built from the first:

1. **`brand/`**, the deliverable folder. Strategy, tokens, the identity mark, the imagery set, 3D objects if any, the motion spec, and a site plan. Everything the site needs, and everything the client keeps.
2. **The site.** Responsive, interactive, cinematic, composed entirely from `brand/`, to the standard of the client's reference corpus.

Working documents live in `taste/`. The client never needs `taste/`; they need `brand/` and the site.

## Two modes

Detect at intake and write it in `taste/INTAKE.md`. Everything downstream branches on it.

- **Greenfield.** A description of a product or service, no code. Phase 1 is the subject audit only. The site is built new under `site/`.
- **Rebrand.** An existing repo, usually AI-generated. Phase 1 adds the design audit and the backend contract. The site is the repo itself, rebuilt with the backend preserved.

## Craft lives in taste-frontend

This skill is the pipeline. The craft it invokes lives in the **`taste-frontend`** skill and is referenced by file at each phase. Two of its files are read before anything else on every engagement, in this order:

1. `taste-frontend/references/PREFERENCES.md`, the client's standing taste law: what has been rejected out loud and what has been approved. It outranks every default.
2. `taste-frontend/references/reference-corpus.md`, the sites the client holds as the standard, torn down technically.

The pipeline names the exact reference file to read at each step. Do not improvise a different route to the same result; those routes were tried and are documented as refused.

## The role: conductor, not painter

The client's own framing: *"je te vois plus en chef d'orchestre."* This skill writes the strategy, the prompts, the Blender scripts, the tokens and the site code, and it directs every generator. It never authors identity artwork with its own hands. Marks, imagery and anything lettered or figurative come from an image model through `taste-frontend/references/asset-generation.md`; objects come from Blender through `blender-pipeline.md`. A hand-plotted SVG mark was shipped once and refused, and the reasoning is recorded in `PREFERENCES.md`.

What the conductor does personally is judge. Every generated asset is opened and looked at before it is kept, and the loop of prompt, look, adjust is the real work of Phase 3.

---

## Phase 0: Intake

Never design on assumptions. Sequence the questions over two or three exchanges rather than one wall; `AskUserQuestion` for anything with discrete options.

1. Product or service description, one paragraph minimum, and the core job it does
2. Target audience, specifically, the first hundred customers
3. Three tone adjectives, pushed past generic ("modern like Stripe or modern like Arc?")
4. Competitor and inspiration URLs, visited in the browser before Phase 2
5. Must-keep constraints
6. Existing brand assets, even informal ones
7. **Mode:** is there a repo? Path or URL if yes. Greenfield if no.
8. **The subject question:** what does this brand have that is worth looking at? A physical product, a body of work, a visible process, a place or craft, or honestly nothing yet. This single answer shapes the whole build; the routes for each answer are in `taste-frontend/references/subject-matter.md`.

Question bank and phrasing: `references/intake-brief.md`. Output: `taste/INTAKE.md`.

---

## Phase 1: Audit

**Both modes:** confirm the subject answer against reality. If the client said "physical product", get the photographs now. If "nothing", pick the route from `subject-matter.md` now, not at build time.

**Rebrand mode only, both outputs mandatory:**

- `taste/AUDIT.md`: every generic-AI pattern present, cited by file and component. Detection list: `references/audit-patterns.md`. Every finding concrete enough to verify fixed in Phase 5.
- `taste/CONTRACT.md`: every API route, the auth flow, data models, integrations, env var names. Extraction: `references/contract-extraction.md`. This is the hard constraint on the rebuild. Anything not written here is fair game to break by accident, which is why it is written.

Also measure the baseline bundle size for the performance budget.

---

## Phase 2: Brand strategy

Where the fee is earned. Everything after this is execution of decisions made here.

Produce `brand/BRAND.md`, template in `references/brand-strategy-template.md`:

- Positioning statement, sharpened until it is false of the named competitors
- Tone of voice as a do/don't table, five rows minimum, none generic
- The narrative: problem, belief, product, proof
- **The motif:** one recurring device derived from the belief, not the category, and the one sentence that explains why it belongs to this brand and no competitor. The identity mark will be built from it. Rules in `taste-frontend/SKILL.md`, the Identity Mandate.
- **The visual register:** premium-minimalist or technical/generative, chosen and justified. Criteria: `taste-frontend/references/visual-registers.md`.
- **The closest corpus reference** and what specifically to take from it, from `reference-corpus.md`.
- **Whether the brief warrants a 3D object.** Only when an object that has no photograph is central to the identity: an extruded mark, an abstract brand form, something the visitor should turn. Not to stand in for a missing product. Criteria in `taste-frontend/references/blender-pipeline.md`.
- Naming or tagline refinement, only if flagged generic

---

## Phase 3: The brand folder

Build `brand/` completely before writing a line of the site. The site is composed from this folder; a site built while its assets are still being invented is how a page ends up as motion polish on nothing.

Folder spec, what goes in each part, and how it is produced: **`references/brand-folder.md`**. The short version:

```
brand/
├── BRAND.md          strategy, from Phase 2
├── tokens.css        colour, type, spacing, motion as custom properties
├── tokens.json       the same, machine-readable
├── logo/             the generated mark: source, keyed variants, sizes, prompt
├── imagery/          the coherent set, eight or more, with prompts.md
├── 3d/               only if Phase 2 said so: script, turntable, glb
├── motion/           motion personality and the set-piece spec
└── site-plan.md      which asset goes where, written before the build
```

Production routes, each proven and each with its documented traps:

- **Mark and imagery:** `taste-frontend/references/asset-generation.md`. Generated, never hand-plotted as SVG. Photography at volume on the free route; lettering on a stronger model. Always looked at before it is kept.
- **3D objects:** `taste-frontend/references/blender-pipeline.md`. Headless, scripted, rendered to a still, looked at, adjusted, then the turntable.
- **Tokens:** `references/design-system-tokens.md`. Written as files, not prose.
- **The asset floor:** eight distinct real assets minimum on a brand page, counted not estimated. `subject-matter.md` has the table per build type.

Phase 3 ends when `brand/site-plan.md` exists and every asset it names is on disk and has been looked at.

---

## Phase 4: The site

Compose from `brand/`, following `brand/site-plan.md`. The composition recipe, scene by scene, is **`taste-frontend/references/site-composition.md`**; the motion craft is `cinematic-scroll.md`; the one interactive moment is `interactivity.md`.

Non-negotiables, each one a documented past failure:

- **Full bleed.** The viewport is the canvas. No boxed layout.
- **Responsive, explicitly.** Every multi-column section declares its collapse under 768px in the same component. Verified at mobile, tablet and desktop widths before Phase 5, not assumed.
- **One interactive moment** that performs the product's claim. One scroll-scrubbed set piece. Everything else on the free motion tiers.
- **Type from `tokens.css`,** licensed or genuinely characterful, never a Google default, never Fraunces.
- **Rebrand mode:** `taste/CONTRACT.md` is a hard constraint. A design that needs a backend change stops and flags it as breaking; it never silently edits backend code.
- **Build with the dev server running** and check incrementally. Never build blind and look once at the end.

Performance budget from `references/performance-budget.md` applies throughout.

---

## Phase 5: Review gate

Mandatory. Produce `taste/REVIEW_SUMMARY.md`, present it directly, and **wait for explicit approval** before Phase 6. Contents and the verification pass, including the responsive check at three widths, console and network errors, reduced motion, the asset-floor count, and, in rebrand mode, every file that touched the contract: `references/review-checkpoint.md`.

Run `taste-frontend`'s pre-flight here too. Every box honest.

---

## Phase 6: Delivery

- **`brand/guidelines.html`**: the brand guidelines as a designed page inside the folder, so the client owns it. Story, mark and usage, colour, type, voice, imagery direction, motion principles with live examples. Structure: `references/delivery-brand-guidelines.md`.
- **Export set** into `brand/logo/` and `brand/social/`: the mark at standard sizes on transparent and solid grounds, favicon set, social sizes for the platforms the client actually uses, og:image.
- **`taste/HANDOFF.md`**: what changed in plain language, how to run the site, where everything is, and in rebrand mode the explicit confirmation that the contract held or the list of approved breaking changes.

---

## Checklist

Copy `references/master-checklist.md` to `taste/CHECKLIST.md` at the start and check it off live. Re-read it after any context reset to recover position.
