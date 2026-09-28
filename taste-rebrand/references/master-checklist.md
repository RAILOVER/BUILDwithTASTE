# Master checklist

Copy to `taste/CHECKLIST.md` at the start of every engagement and check off live. Re-read after any context reset to recover position. Items marked **R** apply to rebrand mode only; everything else applies to both modes.

## Phase 0: Intake
- [ ] Product or service description captured, one paragraph minimum
- [ ] Target audience specific, the first hundred customers
- [ ] Three tone adjectives, pushed past generic
- [ ] Competitor and inspiration URLs collected and actually visited in the browser
- [ ] Must-keep constraints listed
- [ ] Existing brand assets checked
- [ ] **Mode decided:** greenfield or rebrand, written in `taste/INTAKE.md`
- [ ] **Subject question answered:** what this brand has that is worth looking at
- [ ] `taste-frontend/references/PREFERENCES.md` read, live refusals for this build named
- [ ] `taste-frontend/references/reference-corpus.md` read, closest reference named
- [ ] `taste/INTAKE.md` written

## Phase 1: Audit
- [ ] Subject answer confirmed against reality; if "physical product", photographs obtained now
- [ ] If the subject answer is "nothing", the route from `subject-matter.md` chosen now
- [ ] **R** Stack identified: frontend, styling, backend, database, auth, deployment
- [ ] **R** `taste/AUDIT.md` written with file-level citations for every generic pattern
- [ ] **R** `taste/CONTRACT.md` written: routes, auth flow, models, integrations, env var names
- [ ] **R** Baseline bundle size measured

## Phase 2: Brand strategy
- [ ] Positioning statement sharpened until false of named competitors
- [ ] Tone do/don't table, five specific rows minimum
- [ ] Narrative written: problem, belief, product, proof
- [ ] Motif named, with the one sentence tying it to the belief not the category
- [ ] Visual register chosen and justified
- [ ] Closest corpus reference named with what to take from it
- [ ] 3D decision made: warranted or not, and why
- [ ] Naming or tagline refined only if flagged generic
- [ ] `brand/BRAND.md` written

## Phase 3: The brand folder
- [ ] `brand/tokens.css` and `brand/tokens.json` written and loading without error
- [ ] Mark generated via `asset-generation.md`, never hand-plotted; `logo/source.png` and `logo/prompt.md` saved
- [ ] Mark opened and looked at; keyed variants and sizes exported
- [ ] Imagery set planned in `imagery/prompts.md` with one shared treatment string
- [ ] Imagery generated as a set; every image opened and looked at; weak ones cut
- [ ] Asset floor met, counted: eight distinct real assets minimum on a brand page
- [ ] If 3D warranted: `3d/scene.py` written, low-res still rendered and looked at, adjusted, then `turntable/` as WebP
- [ ] `brand/motion/MOTION.md` written: pace, curves, set piece, interactive moment, entrance, reduced motion
- [ ] `brand/site-plan.md` written: one row per scene, every asset named exists on disk, every row has an under-768px answer

## Phase 4: The site
- [ ] Built from `brand/` only, following `site-plan.md` and `site-composition.md`
- [ ] Full bleed, no boxed layout
- [ ] Type imported from `tokens.css`; no Google default, no Fraunces
- [ ] Entrance composed
- [ ] Copy bound to scroll in both directions on chapter scenes
- [ ] Exactly one set piece, media under 5MB
- [ ] Exactly one interactive moment, performing the product's claim, discoverable in one line
- [ ] Numbers set as display moments where the page argues with them
- [ ] Every multi-column section declares its collapse under 768px
- [ ] No hand-rolled smooth scroll; Lenis where loadable, native otherwise
- [ ] Reduced motion collapses everything to a static legible state
- [ ] **R** Zero unflagged deviations from `taste/CONTRACT.md`
- [ ] Dev server running throughout, checked incrementally

## Phase 5: Review gate
- [ ] Verified in the browser at 375, 768 and 1280; every scene looked at on the narrow width
- [ ] Console and network clean
- [ ] Reduced motion tested
- [ ] Scroll tested at normal speed, no dropped frames
- [ ] Asset floor re-counted on the live page
- [ ] `taste-frontend` pre-flight run, every box honest
- [ ] **R** Every `taste/AUDIT.md` item confirmed resolved or explicitly scoped out
- [ ] **R** Every file touching the contract listed, preserved or flagged
- [ ] `taste/REVIEW_SUMMARY.md` written and presented directly
- [ ] **Explicit approval received.** Nothing proceeds without it.

## Phase 6: Delivery
- [ ] `brand/guidelines.html` built as a designed page: story, mark, colour, type, voice, imagery, motion with live examples
- [ ] `brand/logo/` complete: keyed variants, standard sizes, favicon set
- [ ] `brand/social/` complete for the platforms actually used, og image included
- [ ] `taste/HANDOFF.md` written: plain-language summary, run instructions, where everything lives, **R** contract confirmation
