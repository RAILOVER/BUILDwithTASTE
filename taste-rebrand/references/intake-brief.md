# Phase 0: Intake

The goal is to leave with enough specificity that Phase 2 makes real decisions instead of guessing. A brief full of "modern" and "clean" produces a brand full of defaults. Push for specifics here, not later.

## How to run it

Not one wall of eight questions. Two or three exchanges. `AskUserQuestion` for anything with discrete options, plain conversation for the open ones. Keep the client's own words for the description and the tone adjectives; paraphrasing loses the signal.

## The questions

**1. Product or service.** What it does, for whom, and the core job it performs. One paragraph minimum. If one sentence comes back, ask what someone does right before they reach for this and right after it works.

**2. Audience.** Not "everyone". Who the first hundred customers are: role, context, how sophisticated.

**3. Three tone adjectives**, each pushed past generic:
- "Modern": like Stripe (technical, precise, quiet) or Arc (playful, irreverent) or Notion (friendly, calm)?
- "Professional": like a law firm (formal) or Linear (sharp, opinionated)?
- "Clean": like Apple (air and few colours) or a Swiss poster (grid and bold type)?

**4. Competitors and inspirations.** URLs, two to four, at least one direct competitor and one aspiration. Visit every one in the browser before Phase 2.

**5. Must-keep constraints.** Features, pages, flows or integrations that cannot change. In rebrand mode this feeds `CONTRACT.md` directly.

**6. Existing brand assets.** Logo, colours, fonts in informal use. In rebrand mode also read the repo's CSS or Tailwind config before asking; there is usually an accidental starting point.

**7. Mode.** Is there an existing repo?
- Yes, path or clone URL, confirmed accessible: **rebrand mode**. Phase 1 runs the design audit and extracts the backend contract; the site is the repo rebuilt.
- No: **greenfield mode**. Phase 1 is the subject audit only; the site is built new under `site/`.

**8. The subject question.** *What does this brand have that is worth looking at?* Get a concrete answer:
- A physical product: photographs exist or can be taken
- A body of work: real items with real metadata
- A visible process: the product produces output that is interesting to see
- A place, people, a craft
- Honestly nothing yet

This answer shapes the whole build more than any other, and the route for each answer is in `taste-frontend/references/subject-matter.md`. Do not let it slide to "we'll figure it out during design"; that is how a page ends up as motion polish around nothing.

## Before leaving intake

Read `taste-frontend/references/PREFERENCES.md` and name, in one line, which of its refusals are live risks for this brief. Read `taste-frontend/references/reference-corpus.md` and name the closest reference. Both go into `taste/INTAKE.md` alongside the answers, under the same eight headings.
