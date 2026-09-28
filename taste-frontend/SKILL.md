---
name: taste-frontend
description: TASTE agency's design-execution engine. Wraps design-taste-frontend (the anti-slop v2 ruleset) and adds the three things it structurally cannot know, each learned from real rejected work on this account, storytelling structure, cinematic scroll craft calibrated to the client's own reference corpus, and a standing taste file recording exactly what this client refuses and what they have already approved. Use it for any TASTE client build, for Phase 3 and Phase 4 of taste-rebrand, and whenever a page has to prove it has a point of view rather than merely correct execution. Also use it when building anything meant to feel like noireternel, agrumeafarm, a24.raviklaassens, paxter, or dontlookup, when a logo or identity mark is needed, or when a design needs cinematic scroll motion that stays smooth.
---

# taste-frontend

## Where this sits

**`taste-rebrand`** is the engagement pipeline: intake, strategy, the `brand/` folder, the review gate, delivery. It is the entry point for any client project and it names which file here to read at each phase.

**This skill is the craft library** it draws on: the client's taste law, the reference corpus, how assets and 3D objects are produced, how a page is composed from a brand folder, how motion and interaction are built. It also stands alone for a single page that needs the house standard without the full pipeline.

## Read in this order, every time

1. **`references/PREFERENCES.md`** first, before any design decision. It is the client's standing brief: what they have rejected out loud, what they have approved, and how they want to be worked with. It outranks everything else in this file. Skipping it means re-earning verdicts that were already paid for.
2. **`design-taste-frontend` (taste-skill v2)**, the foundation, which is assumed to be installed and followed in full: the three dials, the Locks, the AI-Tells ban list including the complete em-dash ban, the canonical GSAP skeletons, the Redesign Protocol, and its Final Pre-Flight Check. None of that is repeated here.
3. This file, which is an overlay on both.

## The references, by job

| When | Read |
|---|---|
| Deciding what the page is about | `subject-matter.md` |
| Choosing a direction | `reference-corpus.md`, `visual-registers.md` |
| Making the mark and the imagery | `asset-generation.md` |
| Making an object with no photograph | `blender-pipeline.md` |
| Turning a `brand/` folder into a page | `site-composition.md` |
| Building motion | `cinematic-scroll.md` |
| Building the one interactive moment | `interactivity.md` |

## The gap this closes

v2 is an anti-slop system, and an excellent one: its sixty-item ban list attacks generic *execution*. It does not attack the failure one level up, because that is not its job: **correct execution of a generic idea.** A page can pass every v2 checkbox, one accent, one radius system, real images, motivated motion, zero em-dashes, and still be a template with a client's colors poured in. Swapping Inter for a display serif is v2-compliant. It is not a rebrand.

This file was also built the way v2 was built. Its author's stated reason for the v2 rewrite was that soft direction is easy for an agent to skim past, so every observed production failure became a hard, mechanically checkable rule with a code skeleton behind it. Same method here, with this account's own rejections as the evidence.

---

## Step 0: the standing brief

Before touching anything, read `references/PREFERENCES.md` and state in one line which of its refusals are live risks for this particular build. If the brief calls for a logo, the hand-drawn-SVG ban applies. If it calls for a CTA, the generic-button refusal applies. If it displays numbers, the display-numerals rule applies. Naming them up front is what stops them recurring.

Then read the brief against `references/reference-corpus.md` and name the closest corpus site and what specifically to take from it. "Cinematic like noireternel" and "warm and editorial like agrumeafarm" lead to completely different builds; deciding which, out loud, is the first real design decision.

Then answer the subject question below, in writing, before any design work.

---

## Substance before frame

A measured audit of this account's shipped work against the client's corpus produced one finding larger than all the others combined: **the reference sites are frames around beautiful subject matter, and the rejected build was a beautiful frame around nothing.** Those sites carry between 12 and 588 photographic or rendered assets each. The rejected build carried two line drawings, and several rounds went into easing curves and alignment on a page that had nothing in it. Those rounds could not move the outcome, because the missing thing was never the easing.

So, before design starts, answer: **what does this brand have that is worth looking at?** The answer determines the entire shape of the build, and when the honest answer is "nothing photogenic" that is a finding to act on, not to design around. Classification table, the three routes out of the hard case, and the per-build **asset floor** are in **`references/subject-matter.md`**.

Two rules follow directly:

- **Meet the asset floor before pre-flight.** Eight distinct real assets minimum on a landing or brand page. Distinct means different subject matter; the same mark repeated seven times is one asset.
- **When a page feels flat, check the asset count before touching the motion.**

Scale follows too: the corpus is unanimously full bleed, viewport as canvas, imagery to the edges, type set large. A boxed layout reads as a slide deck however well it is composed.

---

## One thing the visitor can do

With the photographic gap closed, a second measurement found the remaining difference between this account's work and the corpus: **every reference has a moment where the visitor acts, and the rebuilt page had one anchor link.** A page that can only be watched is the gap.

This is also the real answer to a brief with no photogenic product. Interaction is subject matter: it costs no photography, and it is the one thing a competitor cannot screenshot.

- **Build exactly one, and make it perform the product's actual claim.** Heron hands you a drawing and lets you drag to find the code violations its agent detects, so the interaction is the proof. A parallax hero proves nothing. Same removal test as the motif: take it away, and does the page lose an argument or just a toy?
- **It must survive being ignored.** Most visitors will not touch it, so it reveals depth rather than gating meaning.
- **When nothing honest fits, ship none.** A page with no interaction beats a page with a custom cursor.

Techniques ranked by cost, the drag-scrub turntable that needs no library, the Heron reveal-on-drag pattern, and what changes inside a CSP-restricted Artifact: **`references/interactivity.md`**.

---

## The Identity Mandate

Identity is expressed structurally or not at all. Two artefacts, neither optional, neither satisfiable by a color token.

### 1. A motif that does work

One recurring device derived from the brand's actual belief, not its category. "Analytics tool" yields a chart, which any competitor could use. "Teams drown in metrics that predict nothing" yields a noise-to-signal waveform, which only this brand can use.

- It appears **at least three times, in different forms**, never as the same icon repeated. A waveform that opens jagged and resolves clean as the page explains the mechanism; a grid that tightens as the claim narrows; a word that does what it describes.
- **The removal test:** delete the motif and reread the page. If only a decoration disappeared, it was an icon. If the structure breaks, it was a motif.
- The identity mark itself should be built from the motif's material, so the mark and the page read as one organism rather than a logo placed on a layout.

### 2. A narrative arc, not a feature list

Order sections by what must become true, in sequence, for the reader to arrive at the belief themselves: problem, belief, mechanism, proof. Not hero, features, social proof, pricing, FAQ, which is ordered by what the company wants to say about itself.

Chaptering and numerals are legitimate here precisely because the order carries information. This is the documented exception to v2's ban on section-number eyebrows, which targets numbering used as filler on non-sequential sections. The test: **would shuffling the sections still make sense?** If yes, drop the numerals, there was no arc. If no, they are earned.

---

## Cinematic direction

The client's favourite reference is a scroll film that stutters, and they have said a smooth version of it would be perfect. That is the standing target. Full teardown, the motion ladder, and working code in **`references/cinematic-scroll.md`**.

The finding that governs everything: **almost everything that makes that site feel expensive is free, and the one thing that makes it stutter is the one thing nobody sees.** Scene-per-viewport structure, copy bound to scroll position in both directions, per-word entrances with varied physics, a composed loader, smooth scroll: all free. Preloading 588 full-resolution frames and repainting a viewport canvas at DPR 2 every scroll frame: that is the jank, and it is not load-bearing for the design.

So:

- Climb the motion ladder only as far as the moment justifies. Tiers 1 to 3, CSS wipes, WAAPI sequences and IntersectionObserver reveals, cover most pages entirely.
- **One scroll-scrubbed set piece per page.** Not three. Spend the heavy technique on the single moment where the mechanism is genuinely visual, and keep everything around it quiet, which is what makes that moment land.
- Media budget for that set piece: under 5MB. Past that, switch from a frame sequence to a scrubbed video.
- Ambient motion on scrolling sections is expected, continuous, and low-amplitude. A section that plays one reveal and freezes reads as dead. A transformation that fires the instant a section enters reads as no animation at all: delay it a beat so the ambient state is seen first.
- Entrance motion fires on scroll, never on page load.
- If a technique cannot be made smooth, simplify it. Never ship stutter as ambition.

---

## Asset generation is delegated

Identity artwork is generated, never hand-authored as SVG path coordinates. Writing coordinates has no visual feedback loop and produced the worst output this account has seen. The role is conductor: write the prompt, direct the generator, judge the result by looking at it. Workflow, working endpoint, the prompt patterns that succeed, this model's documented biases, and the compositing fixes are in **`references/asset-generation.md`**. Accepted assets and the prompts that produced them are in `assets/`.

Hand-authored SVG remains correct for pure geometry the layout depends on: a rule, a wipe mask, a sparkline path. Never for a mark or a letterform.

**Always look at a generated image with the Read tool before integrating it.** The client's judgment is visual; an asset shipped sight unseen is a guess.

### When the brief needs an object that has no photograph

Extruded logos, abstract brand forms, packaging silhouettes, anything a visitor should be able to turn: build it in **Blender**, driven headlessly from a Python script. Scene template, turntable recipe, GLB export and the working method are in **`references/blender-pipeline.md`**.

This is permitted where hand-drawn SVG is banned for one reason: **the feedback loop is real.** Render a still, open the PNG, look at it, adjust, repeat. Looking is mandatory, and rendering 36 turntable frames of a composition nobody checked is the main way to waste time here.

Not for recreating a client's physical product. They own it and can photograph it, which is faster and accurate.

---

## Visual registers

v2's Section 2.B covers the standard aesthetic families. The technical/generative register, monospace as a voice, near-monochrome chrome with color spent only on real output, mechanism exposed as content, is documented with its fit criteria in **`references/visual-registers.md`**. Read its criteria before reaching for it; it is wrong for enterprise-procurement and broad-consumer audiences.

---

## Pre-flight

Run **after** v2's Section 14, not instead of it. Every box honest, or the work is not done.

**Standing brief**
- [ ] `PREFERENCES.md` read, and its live refusals for this build named before starting?
- [ ] Nothing shipped that appears in its Part 1 refusal list?
- [ ] Closest corpus reference named, with what was taken from it?

**Substance**
- [ ] Subject question answered in writing at intake, and the answer visible in the build?
- [ ] Asset floor met, counted rather than estimated, eight distinct real assets minimum on a landing or brand page?
- [ ] Assets generated as a coherent set, shared lighting, medium, palette and framing, not one at a time?
- [ ] Full bleed, viewport as canvas, no boxed layout on cinematic work?
- [ ] Display face licensed or genuinely characterful, never a Google default, never Fraunces or Instrument Serif?
- [ ] Scroll is native or real Lenis, never a hand-rolled lerp?
- [ ] Composed entrance, a loader or counter, rather than starting mid-page?

**Responsive**
- [ ] Looked at, in the browser, at 375, 768 and 1280, every scene on the narrow width?
- [ ] Every multi-column section declares its collapse under 768px in the same component?
- [ ] Every full-bleed image has an `object-position` chosen after seeing it at portrait ratio?
- [ ] Hero headline one line on a phone, body never below 16px, `100dvh` never `100vh`?
- [ ] The interactive moment works with touch and with keyboard?

**Identity**
- [ ] Motif stated in one sentence, traceable to the belief rather than the category?
- [ ] Motif appears three or more times, in different forms, each doing structural work?
- [ ] Removal test run: structure breaks, not just decoration disappearing?
- [ ] Identity mark generated, not hand-plotted, and viewed before integrating?
- [ ] Mark large enough to be the subject where it appears, roughly 140px in a reveal, 50 to 60px in navigation?
- [ ] No visible bounding box on any composited artwork, and correction filters scoped to the elements that need them rather than a shared class?

**Structure**
- [ ] Section order maps to the arc, and shuffling it would break the argument?
- [ ] Every section's children land where the grid says, and nothing touches a divider or boundary?
- [ ] Any number the page argues for set as a display moment, not in the interface font?
- [ ] Any CTA built from the page's own materials, or honestly removed because the surface does not need one?

**Interaction**
- [ ] Exactly one interactive moment, performing the product's actual claim rather than decorating?
- [ ] Removal test run on it: the page loses an argument, not a toy?
- [ ] Discoverable in one line, and the page still reads completely for someone who never touches it?
- [ ] Any 3D object rendered from a script had a still opened and looked at before the full sequence was rendered?
- [ ] Pointer events rather than mouse events, frames preloaded, and a static fallback under reduced motion?

**Motion**
- [ ] Exactly one scroll-scrubbed set piece, everything else on tiers 1 to 3?
- [ ] Set-piece media under 5MB, no preload gate on hundreds of frames?
- [ ] Scrolling sections carry continuous ambient motion, not one frozen reveal?
- [ ] Entrances fire on scroll, not on load?
- [ ] Tested at normal scroll speed, not slowly, with no dropped frames?
- [ ] Reduced motion collapses everything to a static, fully legible state, with canvases removed from the DOM rather than hidden?

**Honesty**
- [ ] What was actually verified in a browser stated plainly, and what was not?
