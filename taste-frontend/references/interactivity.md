# Interactivity

A measured comparison of this account's rebuilt work against the corpus found the photographic gap closed and one gap left open, larger than it looks:

| | Rebuilt page | heronaiapp | a24 | agrumeafarm | dontlookup |
|---|---|---|---|---|---|
| Interactive elements | **1**, an anchor link | drag-to-inspect hero | browsable catalogue | jar slider | fully playable |

**Every reference has a moment where the visitor does something. A page that can only be watched is the remaining difference.**

This is also the answer to "we have no physical product". Interaction is subject matter. It costs no photography, and it is the one thing a competitor cannot screenshot.

---

## What makes an interaction worth building

The test is the same as the motif test: **remove it, and does the page lose an argument or just a toy?**

- **It should perform the product's actual claim.** Heron says its agent spots code violations in your model, then hands you a drawing and lets you drag to find them. The interaction *is* the proof. A parallax hero proves nothing.
- **It should be discoverable in one line.** `CLICK AND DRAG YOUR MOUSE TO SEE VIOLATIONS`. If it needs instructions, it is too clever.
- **It should survive being ignored.** Most visitors will not touch it. The page must still read completely, which means the interaction reveals depth rather than gating meaning.
- **One per page.** Same budget logic as motion: one real interactive moment lands harder than three shallow ones.

Anti-patterns, all of which read as agency-showreel filler: custom cursors, magnetic buttons everywhere, hover-tilt on every card, scroll-jacked section snapping, a WebGL background that responds to the mouse and says nothing.

---

## The ladder, by cost

### 1. Drag-scrub an image sequence (no library, works anywhere)

The workhorse, and the one that pairs with the Blender pipeline. A turntable rendered to 36 frames, indexed by horizontal drag. The object turns under the visitor's finger, it reads as real 3D, and it needs no library.

This is the version that was built and verified in the browser: 36 frames in the DOM, one visible, a quarter-width drag measured as exactly a quarter turn. **Stack all frames as `<img>` elements and toggle a class**; swapping one element's `src` refetches and flickers, and an earlier draft of this file recommended it.

```html
<div class="stage" id="stage" aria-label="Drag to rotate the object" tabindex="0"></div>
```
```css
.stage { position: relative; aspect-ratio: 1; touch-action: none; cursor: grab; user-select: none; }
.stage img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: contain;
             pointer-events: none; opacity: 0; transition: opacity .12s linear; }
.stage img.on { opacity: 1; }
@media (prefers-reduced-motion: reduce) { .stage img { transition: none; } }
```
```js
const FRAMES = 36, stage = document.getElementById('stage');
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
const imgs = []; let idx = 0, startX = 0, startIdx = 0, dragging = false, touched = false;

function show(i) {
  const n = ((i % FRAMES) + FRAMES) % FRAMES;                 // wrap both ways
  imgs[idx]?.classList.remove('on'); idx = n; imgs[idx]?.classList.add('on');
}

// preload everything before enabling the drag, or the first rotation stutters
let loaded = 0;
for (let i = 0; i < FRAMES; i++) {
  const im = new Image();
  im.src = `turntable/f_${String(i).padStart(2, '0')}.webp`;
  im.alt = i === 0 ? 'The object' : '';
  im.onload = im.onerror = () => { if (++loaded === FRAMES) { show(0); if (!reduce) idle(); } };
  imgs.push(im); stage.appendChild(im);
}

// turn slowly on its own until touched, so visitors who never drag still see it move
function idle() { setInterval(() => { if (!dragging && !touched) show(idx + 1); }, 110); }

stage.addEventListener('pointerdown', e => {
  dragging = true; touched = true; startX = e.clientX; startIdx = idx;
  stage.setPointerCapture(e.pointerId);                        // keeps tracking outside the element
});
stage.addEventListener('pointermove', e => {
  if (!dragging) return;
  const perFrame = stage.clientWidth / FRAMES;                 // full width equals one rotation
  show(startIdx + Math.round((e.clientX - startX) / perFrame));
});
const end = e => { if (!dragging) return; dragging = false; try { stage.releasePointerCapture(e.pointerId); } catch (_) {} };
stage.addEventListener('pointerup', end);
stage.addEventListener('pointercancel', end);

stage.addEventListener('keydown', e => {                       // reachable without a pointer
  if (e.key === 'ArrowLeft')  { touched = true; show(idx - 1); }
  if (e.key === 'ArrowRight') { touched = true; show(idx + 1); }
});
```

Why each line is there: **pointer events** cover touch with no extra code; **`setPointerCapture`** keeps the drag alive when the finger leaves the element; **`pointercancel`** handles the browser interrupting a touch; **`touch-action: none`** stops the page scrolling instead of rotating; the **keyboard handler** makes it reachable at all; the **idle spin** stops on first touch so it never fights the visitor.

Budget, measured: **36 frames at 720px, 576KB as WebP.** At 1280px expect roughly 1.5 to 2MB. Render WebP from Blender; the same sequence as PNG was 6.3MB.

### 2. Reveal-on-drag over a still (no library)

Heron's pattern, and the cheapest genuinely meaningful one. A photograph or drawing, with annotations that appear where the visitor drags or clicks. Pure DOM, works in any environment, and it demonstrates an analysis product better than any video of the interface.

### 3. Canvas 2D interaction (no library)

Particles that respond, a waveform the visitor can scrub, a simple simulation. Cheap, but only when the thing being simulated is the product's actual subject.

### 4. Real 3D in the browser

A `.glb` from Blender rendered with WebGL, orbit controls, real lighting. The strongest version, and the most expensive.

**Environment decides feasibility.** On a client site, import Three.js normally. **Inside a published Artifact, the CSP blocks every external script**, so Three.js has to be inlined into the page, which is a large amount of bundled code. In that case prefer the drag-scrub turntable, which delivers most of the effect with none of the payload.

Always ship a static fallback frame for reduced motion and for load failure.

---

## Deciding

| Brief | Reach for |
|---|---|
| Physical product, client has it | Drag-scrub turntable, rendered from a photograph or a Blender scene |
| Software, analysis, or diagnosis | Reveal-on-drag over the product's real output, the Heron pattern |
| Generative or procedural tool | Canvas interaction running the actual process |
| Catalogue or body of work | Make browsing itself the interaction, the A24 pattern |
| Nothing fits | Ship no interaction rather than a decorative one |

That last row is real. A page with one honest interaction beats a page with three ornamental ones, and a page with none beats a page with a custom cursor.
