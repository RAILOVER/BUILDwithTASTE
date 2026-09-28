# Cinematic scroll without the jank

The client's favourite site stutters, and they have said plainly that a version of it that stayed smooth would be perfect. That is the brief this file answers.

The core finding from tearing it down: **almost everything that makes noireternel feel expensive is free. The one thing that makes it stutter is the one thing nobody actually sees.** Separate those and the problem is solved.

---

## What noireternel actually does

Read from its own `js/app.js`.

```
6 scenes x 98 frames  = 588 WebP images
all preloaded upfront behind a loader gate
painted into a full-viewport 2D canvas at devicePixelRatio (capped 2)
GSAP ScrollTrigger per scene: start 'top top', end 'bottom top', scrub: 1.8
  onUpdate -> frame index = round(sceneStart + progress * (frames - 1)) -> ctx.drawImage
plus a live Three.js beam field behind it, dimmed past 50vh
```

Text handling, which is the genuinely good part:

```js
ScrollTrigger.create({
  trigger: sceneEl,
  start: '35% top',
  end: '95% top',
  onEnter:     () => tw.classList.add('visible'),
  onLeave:     () => tw.classList.remove('visible'),
  onEnterBack: () => tw.classList.add('visible'),
  onLeaveBack: () => tw.classList.remove('visible'),
});
```

All four handlers. The copy appears *and* disappears, forward and backward, and CSS transitions do the actual fading. GSAP only toggles a class. That pattern is free and it is most of the feel.

Its kinetic type scene gives each word its own direction and its own ease: `x: -80` with `power3.out`, `x: 80` delayed, `y: -50`, `y: 60`, then a final word on `elastic.out(1, 0.5)` from `scale: 0.3, rotateZ: -180`. Different physics per word is why it reads as choreography rather than a stagger.

**Why it janks:** 588 decoded images is roughly 50MB or more resident, and every scroll frame repaints a full-viewport canvas at DPR 2. Nothing about the *design* requires that.

---

## The free tier: structure and timing

These cost nothing and deliver most of the impression. Exhaust this tier before spending anything.

**One idea per full viewport.** `min-height: 100dvh` per scene, never `100vh`. A screen holding one line and a lot of air is the single strongest lever in the whole corpus.

**Text bound to scroll in both directions.** The four-handler pattern above, or `IntersectionObserver` plus CSS transitions when GSAP is not in the project. Copy that appears and then stays forever reads as a document; copy that comes and goes reads as a film.

**Chapter numerals.** Roman or arabic, set large and low-contrast behind the content. Earns its place only when the order carries meaning.

**Per-word entrance with varied physics.** Different direction and different ease per word. Free in CSS with per-element delays, or Motion/GSAP if present.

**A composed entrance.** A loader or counter, even a brief one. Several corpus sites do this and it is part of why they feel authored.

**Smooth scroll.** Lenis, initialised once at the app root and driving the scroll for everything else.

```js
import Lenis from 'lenis';
const lenis = new Lenis({ duration: 1.1, smoothWheel: true });
function raf(t) { lenis.raf(t); requestAnimationFrame(raf); }
requestAnimationFrame(raf);
// if GSAP is present, let ScrollTrigger read Lenis's scroll position
lenis.on('scroll', ScrollTrigger.update);
```

**Do not hand-roll a wheel-lerp substitute when Lenis cannot be loaded.** This was tried in production and failed twice before the cause was diagnosed correctly.

The reason is not calibration. **Windows already applies its own smoothing to mouse wheel input**, so a lerp on top of it double-smooths: the page keeps travelling after the wheel stops and becomes hard to steer. Two passes were shipped and rejected, at `0.13` (*"le ralentissement est trop prononce, on navigue difficilement dessus"*) and again at `0.26` (*"toujours trop hardcore"*), before the platform behaviour was identified as the actual problem. Tuning the constant could never have fixed it.

Native scroll is the correct answer where Lenis is unavailable. The cinematic quality comes from the scene reveals, not from scroll physics, and the rebuilt page reads as intended without any smoothing at all.

Two lessons worth keeping beyond this case: when two calibration passes both fail, stop tuning the constant and question the mechanism; and a technique that is standard on one platform is not automatically portable to another that already provides it.

---

## The motion ladder

Climb only as far as the moment justifies. Each rung states what it costs.

### 1. CSS wipe on a generated raster (near zero)

Reads exactly like a line drawing itself, with none of the cost. This is what was accepted as *"NIQUEL"* on the Pulseboard build. Generate the artwork, then reveal it with `clip-path`.

```css
.motif { clip-path: inset(0 100% 0 0); opacity: 0; }
```
```js
el.animate(
  [{ opacity: 0, clipPath: 'inset(0 100% 0 0)' },
   { opacity: 1, clipPath: 'inset(0 0% 0 0)' }],
  { duration: 1100, easing: 'ease-in-out', fill: 'forwards' }
);
```

Prefer this over animating an SVG `stroke-dashoffset` whenever the artwork is raster. Never put a heavy filter on a class shared with photographic or line artwork; scope filters to the element that needs them, or the wipe visibly degrades.

### 2. Sequenced reveal with the Web Animations API (near zero)

For a cold open where beats must land in a fixed order, `await` on `.finished` is exact and readable, and it cannot drift the way chained timeouts do.

```js
const play = (el, frames, opts) => el.animate(frames, opts).finished;
const wait = ms => new Promise(r => setTimeout(r, ms));

async function coldOpen() {
  let i = 0;
  await play(reveals[0], [{ opacity: 0 }, { opacity: 1 }], { duration: 600, fill: 'forwards' });
  for (;;) {
    await wait(2600);                                   // hold, long enough to read
    await play(reveals[i], [{ opacity: 1 }, { opacity: 0 }], { duration: 500, fill: 'forwards' });
    await wait(200);                                    // true black, nothing on screen
    await play(motif, wipeIn, { duration: 1100, easing: 'ease-in-out', fill: 'forwards' });
    await wait(250);
    const next = (i + 1) % reveals.length;
    await Promise.all([                                 // motif out and next content in, together
      play(motif, fadeOut, { duration: 400, fill: 'forwards' }),
      play(reveals[next], [{ opacity: 0 }, { opacity: 1 }], { duration: 600, fill: 'forwards' }),
    ]);
    motif.style.clipPath = 'inset(0 100% 0 0)';         // reset for the next pass
    i = next;
  }
}
```

Order is load-bearing and was corrected once in production: content clears the screen *completely* before the motif wipes again. Never leave the identity mark sitting static waiting for the next beat.

### 3. IntersectionObserver reveals (near zero)

Two distinct patterns, and an earlier draft of this file conflated them.

**Bidirectional, for chapter scenes.** The noireternel pattern without GSAP: copy appears when the scene enters and leaves when it leaves, both directions. `toggle`, and **never `unobserve`**, or it fires once and the page reads as a document instead of a film.

```js
const io = new IntersectionObserver(entries => {
  entries.forEach(e => e.target.classList.toggle('in', e.isIntersecting));
}, { threshold: 0, rootMargin: '-12% 0px -12% 0px' });
document.querySelectorAll('[data-scene]').forEach(el => io.observe(el));
```

The `threshold: 0` with a negative `rootMargin` is deliberate. Scenes are roughly viewport-sized, so a ratio threshold like `0.3` is fragile on short screens and can leave copy stuck invisible; "any part of the block inside the middle band" is robust at every height. This was found the hard way.

**One-shot, for ordinary sections.** Reveal once and stop observing, so it does not re-run on every pass.

```js
const once = new IntersectionObserver(entries => {
  for (const e of entries) if (e.isIntersecting) { e.target.classList.add('is-in'); once.unobserve(e.target); }
}, { threshold: 0.15 });
document.querySelectorAll('[data-reveal]').forEach(el => once.observe(el));
```

When a section also has continuous ambient motion, delay the resolving transition by a beat so the ambient state is actually seen before it resolves. A transformation that fires the instant a section scrolls in reads as no animation at all.

### 4. Bounded 2D canvas for ambient fields (low)

Fine for drifting lines, grain, noise. Three rules keep it cheap: cap DPR at 2, pause it with an `IntersectionObserver` whenever it leaves the viewport, and remove it entirely under reduced motion.

```js
const io = new IntersectionObserver(es => es.forEach(e => e.isIntersecting ? start() : stop()), { threshold: 0 });
```

### 5. Video scrub (medium)

One hardware-decoded file instead of hundreds of images. This is the direct replacement for a frame sequence when the motion is photographic.

```html
<video id="film" src="/scene.mp4" muted playsinline preload="auto"></video>
```
```js
ScrollTrigger.create({
  trigger: section, start: 'top top', end: 'bottom top', scrub: 1,
  onUpdate: self => { if (film.readyState >= 2) film.currentTime = self.progress * film.duration; }
});
```

Caveats worth knowing before committing: seek accuracy varies by codec and browser, so encode with a short keyframe interval (every 5-10 frames) or scrubbing will feel notchy. iOS needs `muted` and `playsinline` or it refuses inline playback. Roughly 2-5MB versus 50MB+ for the equivalent frame sequence.

### 6. Reduced frame sequence (medium, only when video will not do)

If the motion genuinely needs frame-exact control, budget **40-60 frames, not 588**, at a bounded width (1280 is plenty), decoded off the main thread and only for the scene about to enter.

```js
async function loadScene(paths) {
  return Promise.all(paths.map(async p => {
    const res = await fetch(p);
    return createImageBitmap(await res.blob());   // decoded off-thread, cheap to draw
  }));
}
```

Load the current scene and prefetch only the next one. Never gate the whole page behind a preload of everything.

### 7. Fixed-size WebGL canvas (high, but bounded)

What A24 does: one 1280x720 WebGL canvas, scaled up by CSS, with exactly one ScrollTrigger registered. Smooth precisely because the backing store is fixed and modest rather than viewport-sized at DPR 2. Reach for it only when the whole page is the render surface.

### Banned

Preloading hundreds of full-resolution frames behind a loader gate, and repainting a viewport-sized canvas at DPR 2 on every scroll frame. This is the one thing in noireternel to leave behind.

---

## Budget

For a page with one cinematic set piece:

- One scroll-scrubbed moment. Not three.
- Media for it: under 5MB. If a frame sequence exceeds that, switch to video.
- Everything else on the page: tier 1 to 3 only.
- `transform` and `opacity` for anything continuous; they are the compositor-only properties. `clip-path` is fine for a one-shot wipe but it repaints, so never loop it. Never `top`, `left`, `width`, `height`.
- Every scroll-driven moment tested at normal scroll speed, not slowly.
- Reduced motion collapses every tier to a static, fully legible state.

---

## Reduced motion

Non-negotiable, and easy if planned. The cold open becomes a static stack of all its lines. Ambient canvases are removed from the DOM, not merely hidden. Scrubbed media jumps to a representative frame and stops.

```css
@media (prefers-reduced-motion: reduce) {
  [data-reveal], [data-scene] .copy { opacity: 1 !important; transform: none !important; transition: none !important; }
  .cold-open-line { position: static; opacity: 1; }     /* every line of the sequence, stacked and readable */
  .entrance { display: none; }
}
```

```js
if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) { canvas.remove(); return; }
```
