# The brand folder

`brand/` is the deliverable. It is built completely in Phase 3, before any site code, and the site in Phase 4 is composed from it and nothing else. If something the site needs is not in this folder, the folder is not finished.

Two reasons this order is enforced. First, the client keeps the folder and can hand it to anyone; a site that hides its brand inside its own CSS gives the client nothing portable. Second, a documented failure: several rounds went into easing and alignment on a page that had no assets in it, and none of those rounds could move the outcome. Fill the folder first.

---

## Layout

```
brand/
├── BRAND.md              strategy, from Phase 2
├── tokens.css            colour, type, spacing, radius, motion, as CSS custom properties
├── tokens.json           the same values, machine-readable
├── logo/
│   ├── source.png        the generated mark exactly as it came back
│   ├── prompt.md         the prompt that produced it, and the generator
│   ├── mark-dark.png     keyed for a dark ground
│   ├── mark-light.png    keyed for a light ground
│   ├── mark-512.png … mark-64.png
│   └── favicon/          16, 32, 48, apple-touch 180
├── imagery/
│   ├── prompts.md        the shared treatment string, then one line per image
│   └── 01-<subject>.jpg … 0N-<subject>.jpg
├── 3d/                   only when Phase 2 decided the brief warrants an object
│   ├── scene.py          the Blender script that built it
│   ├── still.webp        the approved still, looked at before the sequence was rendered
│   ├── turntable/        f_00.webp … f_35.webp
│   └── model.glb         only when a real 3D target exists
├── motion/
│   └── MOTION.md         pace, easing, what earns motion, the set piece, the interactive moment
├── social/               produced in Phase 6: og image, profile and cover sizes actually needed
├── guidelines.html       produced in Phase 6: the brand guidelines as a designed page
└── site-plan.md          which asset goes where, written last, before any code
```

---

## Each part, and how it is produced

### BRAND.md

Copied from Phase 2 unchanged. It carries the positioning, the tone table, the narrative, the motif and its one-sentence justification, the register, the closest corpus reference, and the 3D decision.

### tokens.css and tokens.json

Written as files, not described in prose, so the site imports them and the client can reuse them. Derivation rules: `design-system-tokens.md`. A complete example from a shipped build:

```css
:root {
  /* ground and ink, chosen not defaulted */
  --ground: #f2ede3;
  --ink: #1e1a15;
  --ink-soft: #554e44;
  --faint: #8c8478;
  --rule: #ddd5c6;
  --accent: #2f4538;

  /* type, licensed or genuinely characterful, never a Google default */
  --display: 'Newsreader', Georgia, serif;
  --sans: 'Familjen Grotesk', system-ui, sans-serif;
  --mono: 'JetBrains Mono', ui-monospace, monospace;
  --scale: 1.333;

  /* spacing, one scale used everywhere */
  --s1: 4px; --s2: 8px; --s3: 16px; --s4: 24px; --s5: 40px; --s6: 64px; --s7: 104px;

  /* one radius system per page */
  --radius: 0;

  /* motion, one pace, two named curves */
  --ease-out: cubic-bezier(.22, 1, .36, 1);
  --ease-in-out: cubic-bezier(.4, 0, .2, 1);
  --t-fast: 300ms;
  --t-slow: 800ms;
}
```

`tokens.json` mirrors the same keys and values. Dark-mode values, when the brand has them, are a second block under `@media (prefers-color-scheme: dark)` in the CSS and a `dark` object in the JSON.

### logo/

**Generated, never hand-plotted as SVG path coordinates.** Route, prompt patterns that work, the generator's documented biases, and the compositing fixes: `taste-frontend/references/asset-generation.md`.

Be honest about the format. Generation produces raster. `source.png` is the mark as it came back; the keyed variants are the same mark with the background removed or crushed to the ground colour, per the compositing section of that file. There is no SVG unless the mark is pure geometry that was built in Blender and exported, or unless the client commissions a vectorisation later. Do not promise an SVG the pipeline cannot produce.

`prompt.md` records the exact prompt and which generator, so the mark can be regenerated or varied later.

The mark is the subject wherever it appears. Expect roughly 140px tall in a reveal and 50 to 60px in navigation; the sizes exported here serve those, not a 22px favicon-scale garnish.

### imagery/

The asset floor: **eight distinct real assets minimum** on a brand page, twelve preferred. Distinct means different subject matter; the same mark repeated is one asset. Per-build-type floors are in `taste-frontend/references/subject-matter.md`.

Generate as **one coherent set**, not one at a time. `prompts.md` opens with the shared treatment string, then lists one line per image with only the subject varying:

```
Treatment: 35mm film photograph, fine grain, single soft window light from the left,
muted warm palette, shallow depth of field, quiet editorial still life, desaturated,
no text, no logos

01-dawn-desk      an empty wooden desk at dawn, low sun casting long shadows, a closed laptop
02-hands          close crop of hands resting on a laptop keyboard, warm morning light
03-notebook       an open paper notebook with handwriting beside a ceramic cup on linen
…
```

Every image is opened and looked at before it is kept. Overshoot and cut: ten generated, six kept, is a normal ratio.

### 3d/

Only when Phase 2 decided the brief warrants an object, and never to stand in for a missing product. Full method, the four traps, and the turntable recipe: `taste-frontend/references/blender-pipeline.md`.

`still.webp` is the approved composition, arrived at by rendering low, looking, adjusting, three or four passes. Only then is `turntable/` rendered, as WebP, 36 frames. `model.glb` only when the site target can load a 3D library; inside a CSP-restricted Artifact it cannot, and the turntable does the job instead.

### motion/MOTION.md

The motion personality made concrete, so Phase 4 never invents motion ad hoc:

- **Pace:** snappy (100 to 200ms) or languid (300 to 500ms), one choice for the whole site
- **The two named curves** from `tokens.css` and where each is used
- **What earns motion**, and what stays still
- **The one set piece:** which asset, which technique from the motion ladder in `cinematic-scroll.md`, and its media budget under 5MB
- **The one interactive moment:** which asset, which technique from `interactivity.md`, and the one-line hint the visitor sees
- **The entrance:** loader, counter, or sequence
- **Reduced motion:** what each of the above collapses to

### site-plan.md

Written last, after every asset exists, and before any code. Recipe: `taste-frontend/references/site-composition.md`. It is a table, one row per scene: the scene's job in the narrative, the asset it uses, the copy (one line), the motion tier, and what it does under 768px.

---

## Phase 3 is finished when

- [ ] Every file in the layout above exists, or its absence is explained in `site-plan.md` (3D is optional; nothing else is)
- [ ] The asset floor is met, counted
- [ ] Every image in `logo/`, `imagery/` and `3d/` was opened and looked at, and none was kept sight unseen
- [ ] `tokens.css` loads without error in a blank page
- [ ] `prompts.md` and `logo/prompt.md` record enough to regenerate anything
- [ ] `site-plan.md` names an asset for every scene, and every asset it names is on disk
