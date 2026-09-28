# Site composition

How a finished `brand/` folder becomes a page. This is the recipe Phase 4 of the pipeline follows, and the shape every reference in the corpus shares once their differences are stripped away.

The input is the folder. If an asset the page needs is not in `brand/`, stop and go back to Phase 3; do not invent it mid-build.

---

## The shape

Every corpus site, reduced to its skeleton:

```
entrance      a composed arrival, not a page that pops in
nav           the mark, and one or two plain links
hero          one full-viewport scene, the strongest asset, one line
chapters      one full-viewport scene each, one asset each, one idea each
set piece     one scene where the motif transforms or an object turns
interaction   one moment the visitor performs the product's claim
proof         one real quote, or real numbers set as a display moment
close         the last full-viewport scene, one line, one asset
footer        the mark and a few words
```

Scenes are the unit. A scene is `min-height: 100dvh`, one asset filling it edge to edge, a small amount of copy bound to scroll position, and nothing competing. The corpus is unanimous on this and it is the single strongest lever available.

---

## Writing site-plan.md

One row per scene, before any code:

| # | Job in the narrative | Asset | Copy, one line | Motion tier | Under 768px |
|---|---|---|---|---|---|
| 0 | Entrance | none | counter or loader | WAAPI sequence | same |
| 1 | Hero, the claim | `imagery/01-dawn-desk.jpg` | Three numbers that predict your week. | scale-settle, word entrance | same, type scale down |
| 2 | Problem | `imagery/04-meeting-room.jpg` | Forty widgets, all green, none of them true. | scroll-bound copy | same |
| 3 | Belief, the set piece | `3d/turntable/` | We deleted thirty-seven of them. | drag-scrub turntable | tap-drag, frames preloaded |
| 4 | Product, the numbers | `imagery/09-linen.jpg` as texture | Each one earns its place every week. | staggered reveal | single column |
| 5 | Proof | `imagery/02-hands.jpg` | the quote | scroll-bound copy | same |
| 6 | Close | `imagery/08-empty-chair.jpg` | The best weeks end quietly. | scroll-bound copy | same |

The narrative column comes from `BRAND.md`: problem, belief, mechanism, proof. The order must carry meaning; if the rows could be shuffled without loss, there is no arc and the chapters are decoration.

The **Under 768px** column is mandatory for every row. A scene with no answer there is not planned.

---

## Composing each part

### Entrance

A counter in the display face at the corpus scale, a boot sequence, or the cold-open sequence documented in `PREFERENCES.md`. Fixed, full viewport, fades out on completion. Under reduced motion it does not render at all.

### Nav

The mark from `logo/`, sized to be read, 50 to 60px. One or two plain text links in the mono face, no pill buttons. `mix-blend-mode: difference` over full-bleed imagery keeps it legible on any ground. Absolute over the hero, not sticky, unless the brief is a catalogue.

### Hero

The strongest image in `imagery/`, `object-fit: cover`, a gradient scrim from the bottom so copy reads, and one line of copy in the display face with a per-word entrance. Headline two lines maximum on desktop, one on mobile. No subtext beyond twenty words. No button unless the brief is an actual signup flow; the corpus does not open on a call to action.

### Chapters

One asset, one chapter number, one headline, one short paragraph, bottom-anchored over the image. Copy is bound to scroll in **both directions**, the noireternel pattern: it appears when the scene enters and leaves when the scene leaves. The implementation is in `cinematic-scroll.md`; the important detail is `toggle`, not `unobserve`.

A slow scale-settle on the image (1.06 to 1.0 over about two seconds) as the scene enters gives every chapter a breath of life at zero cost.

### The set piece

One per page. The motif transforming, or the 3D object turning, or the product's output revealing itself. The heaviest technique on the page lives here and only here; everything else stays on the free tiers so that this moment lands. Media under 5MB. Tier choice: `cinematic-scroll.md`, the motion ladder.

### The interactive moment

One per page, and it performs the product's actual claim. A turntable to turn, a drawing to drag across, a process to run. Discoverable in one line. Survives being ignored. Rules and the ladder: `interactivity.md`. Often the set piece and the interactive moment are the same scene; that is fine and usually best.

### Numbers

Any figure the page argues for is a display moment: the display face at 38px or larger, `font-variant-numeric: tabular-nums`, the number as the largest element in its row, a small motif-derived sparkline beside it. Never the interface font. This treatment was explicitly approved.

### Proof

One real quote, three lines maximum, real attribution with role and context. Or real numbers, treated as above. Never a row of invented testimonials, never a fake logo wall.

### Plans, if any

Honest and plain. Two tiers in a grid with a hairline, the amount in the display face, no "most popular" badge, no manufactured urgency. The reason a second tier exists, stated in one sentence.

### Close

A final full-viewport scene, the quietest image in the set, one line. The page ends on an image, not on a form.

### Footer

The mark, small, and a few words. Nothing else.

---

## Responsive, explicitly

The corpus was torn down at desktop width. Do not assume a scene survives a phone.

- **Type:** display sizes via `clamp()`, and the hero headline drops to one line under 768px. Body never below 16px.
- **Scenes:** full viewport still holds on a phone. `100dvh`, never `100vh`, or iOS chrome will cause a jump.
- **Images:** `object-fit: cover` plus an `object-position` per image chosen after looking at it on a narrow viewport; the subject of a landscape photograph often sits off-centre and gets cropped out.
- **Grids:** every multi-column section collapses to one column under 768px, declared in the same component, not left to chance.
- **Turntable:** pointer events already cover touch. `touch-action: none` on the element, and the drag distance for one rotation is the element width, which shrinks with the viewport and so stays natural.
- **Nav:** `mix-blend-mode: difference` still works; padding tightens to 22px.
- **Verify** at 375, 768 and 1280 in the browser before review, and look at every scene at 375. Reading the CSS is not verification.

---

## What not to add

Because each has been rejected on this account or in the corpus: a button-shaped button in the default UI font, a boxed layout, a second set piece, a second interactive moment, a hand-rolled smooth scroll, motion on page load, a section that plays once and freezes, a wordmark standing in for a mark, and any asset that was not looked at first.
