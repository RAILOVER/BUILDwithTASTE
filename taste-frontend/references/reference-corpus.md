# Reference corpus

Sites the client has named as the standard, each torn down in the browser rather than described from memory: fonts read off the computed styles, libraries detected on `window`, canvases and media counted in the DOM. Use this to answer "what does good look like here" with specifics instead of adjectives.

Discovery source for most of these: **muz.li** (me.muz.li). When the corpus needs refreshing, that is where the client finds work they like.

**How to use this file.** Do not clone a corpus site. Identify which one the current brief is closest to in *kind* (scroll-film, catalogue, playable, tool), then steal the specific mechanism named under "what to take" and drop the rest. Every entry also states what the technique costs, because several of these sites are expensive and one of them visibly stutters.

---

## The through-line

Before the individual entries, what all seven share, because this is the actual house standard:

1. **Licensed display type, every single one.** Pangram Pangram (PP Neue Montreal, PP Eiko, PP Museum), Adobe Fonts (ivystyle-sans, ivymode), or custom (Marsipan). Not one Google Fonts default anywhere. Where a face cannot be licensed, the fallback is a plain system stack used deliberately, never Inter used defensively.
2. **Very little text per screen.** Agrumea's hero is one sentence plus "scroll to discover".
3. **Rendered imagery.** Canvas or WebGL appears in all of them, but always solving something specific rather than decorating.
4. **A composed entrance.** Loader, counter, or opening sequence. None of them just appear.
5. **Grounds are warm or absolute.** Cream, bone, light grey, true black. No default white, no navy-tinted dark.
6. **One concept, stated confidently.** Each site is about a single idea and trusts it.

---

## noireternel.vercel.app

The client's stated favourite, and the one whose flaw is named out loud: it stutters, and *"si y'avait pas de bug ce serait vraiment le parfait parfait exemple."* It gets its own file because matching it cheaply is the central technical problem of this skill. See `cinematic-scroll.md` for the full architecture and the cheap equivalents.

Short version: six full-viewport scenes, 98 WebP frames each, 588 images preloaded behind a loader gate, painted to a 2D canvas and scrubbed by GSAP ScrollTrigger at `scrub: 1.8`, with a live Three.js beam field behind everything. Text per scene toggles a `.visible` class on enter and leave so it appears *and* disappears with scroll position. One scene runs a kinetic type set piece where each word enters from a different direction on a different ease.

**What to take:** the scene-per-viewport structure, text bound to scroll position in both directions, the multi-direction multi-ease word entrance, the chapter numerals, the single ambient light source.

**What it costs:** 588 decoded images held in memory and a full-viewport canvas repaint every scroll frame. This is the jank. Do not copy the preload.

---

## agrumeafarm.it

Sicilian citrus preserves. The warmest, most editorial page in the corpus.

| | |
|---|---|
| Ground | `rgb(253,243,235)` warm cream |
| Text | `rgb(118,37,48)` deep wine, not black |
| Type | `ivystyle-sans` with `ivymode` serif, both Adobe Fonts |
| Stack | No GSAP, no Three, no Lenis. One bundled script. |
| Media | 12 images, **10 canvases** |

The ten canvases are the detail worth studying: every one is `jar-slider__label` at 265x427, 2D context. They are rendering each jar's paper label, curved to the jar's cylinder. Canvas is being used to solve a typographic problem a flat image could not, and for nothing else on the page.

**What to take:** colored text instead of black (the wine red does enormous work), a serif-with-sans pairing where the serif is the voice rather than an accent, near-empty hero, and above all the idea of reaching for canvas to solve one specific rendering problem rather than to add spectacle.

**What it costs:** almost nothing. This is the cheapest site in the corpus and arguably the most refined. When a brief is warm, editorial, or product-led, this is the model, not noireternel.

---

## a24.raviklaassens.com

A24's film library rebuilt as a WebGL catalogue. The full awwwards stack, executed cleanly.

| | |
|---|---|
| Ground | `rgb(242,242,242)` light grey, black text |
| Type | PP Neue Montreal 500, PP Eiko, PP Museum (Pangram Pangram) |
| Stack | **GSAP + ScrollTrigger + Lenis + Three.js + Barba**, on Astro |
| Media | **Zero `<img>`, zero `<video>`, one 1280x720 WebGL canvas** |

Everything visible is drawn in WebGL at a fixed 1280x720 backing size, which is why it stays smooth where noireternel does not: one bounded canvas rather than a full-viewport repaint at device pixel ratio. Exactly one ScrollTrigger is registered. Lenis provides the scroll feel.

Content is dense and real: director, year, full cast, two press quotes with star ratings, disc artwork per film. The site is a catalogue that happens to be cinematic, not a mood piece.

**What to take:** the restrained ScrollTrigger count, the fixed-size canvas instead of a viewport-sized one, Lenis, and the willingness to present genuinely dense editorial data inside an art-directed shell. Also the type stack: three weights of one family plus two display faces is a complete system.

**What it costs:** real WebGL engineering and licensed fonts. Reach for it when the brief is a catalogue or a body of work, not a single product.

---

## paxter.info

| | |
|---|---|
| Ground | White, near-black text |
| Type | Helvetica Neue with Times New Roman, plus Inter Tight |
| Stack | Next.js with Turbopack, many chunked bundles |
| Media | **16 videos, 136 images**, one canvas |
| Entrance | Opens on a `[0%]` counter |

The typography is the point: Helvetica and Times, the two most default faces in existence, used on purpose as an editorial position. That only works when everything else is immaculate, and here it is. The title is `[pax] [pax] [pax]`.

**What to take:** the bracket motif carried into the page title itself; the loading counter as part of the identity; and the permission to use plain system faces *as a statement* when the concept supports it. Note the distinction in `PREFERENCES.md`: this is deliberate plainness, not defensive Inter.

**What it costs:** 16 videos and 136 images is a heavy page. Justified here because the work being shown is the product.

---

## dontlookup.app

Not a website. A playable game about wealth inequality, and the best copy in the corpus.

| | |
|---|---|
| Ground | `rgb(244,243,239)` warm bone |
| Text | `rgb(20,20,15)` warm near-black |
| Type | Nunito with **Marsipan**, rounded, custom |
| Media | 58 images, one canvas |
| Controls | Keyboard: space, 1-9, escape, arrows |

Live counters tick continuously ($792.0M, $0 per second, elapsed time). The interface teaches its own mechanics through labels rather than a tutorial wall. The opening line: *"You are very rich, very tall, and standing on quite a lot of people."* The analytics consent notice is written in plain human language and explicitly says the game plays identically either way.

**What to take:** interaction as the argument rather than copy about the argument; live numbers that never stop moving; consent and system copy written like a person wrote it; warm bone rather than white.

**What it costs:** it is a game. The relevant lesson is tonal and structural, not technical.

---

## heronaiapp.com

**The most important entry for software briefs**, because it is the only reference that has no photogenic subject and reaches corpus quality anyway. An AI agent for architects checking building-code compliance inside Revit and Rhino. Designed by Bearplus.

| | |
|---|---|
| Ground | Near-white, text `rgba(40,40,40,.72)` |
| Type | **BT Grotesk** with **Geist Mono**, both licensed |
| Stack | **GSAP + ScrollTrigger + Lenis + Barba**, on Webflow |
| Media | 45 images, zero video, one 2D canvas, **no 3D at all** |

How it solves having nothing to photograph, which is the whole lesson:

- **The product's output is the subject.** Code-violation callouts rendered over architectural drawings: `IBC 1015.3 GUARDRAIL REQUIRED FOR FALL PROTECTION`. Real, specific, and visually rich because the work itself is.
- **The hero is playable.** `CLICK AND DRAG YOUR MOUSE TO SEE VIOLATIONS`, with live X/Y coordinates. The visitor performs the product's core action before reading a word about it.
- **A boot sequence as the loader.** `001 INITIALIZE CORE SYSTEM` through `010 START EXECUTION`, plus a spec block reading `TYPE / FOUNDED / FOCUS / LOCATION`.
- **Problems named in one word each**, numbered: `MANUAL [01]`, `DISJOINTED [02]`, `BLIND [03]`, `SLOW [04]`.
- **`[SCROLL TO CONTINUE]`** between narrative beats, making the scroll an explicit reading contract.

**What to take:** for any product without a physical object, stop looking for something to photograph and make the product's *output* the imagery, then make one moment of it interactive. Also the licensed-mono pairing and the boot-sequence entrance.

**What it costs:** 45 images and four libraries, but no 3D and no video. Entirely reachable.

---

## dithergarden.com

| | |
|---|---|
| Ground | White, black text |
| Type | JetBrains Mono throughout, body copy included |
| Concept | Image dithering tool that exposes its own algorithm list |

Names all fifteen dithering algorithms in the interface (Floyd-Steinberg, Atkinson, Stucki, Bayer, Blue-Noise, Riemersma). Process transparency as the entire design position. Covered in full in `visual-registers.md` as the technical/generative register.

**What to take:** monospace as a voice rather than a code style; the product's mechanism surfaced as content; color spent only on generated output, never on chrome.

---

## Reading a brief against this corpus

| Brief shape | Closest reference | Take |
|---|---|---|
| **Software, nothing to photograph** | **heronaiapp** | **The product's output becomes the imagery, and one moment of it is playable** |
| Single product, story to tell | noireternel | Scene-per-viewport chapters, scroll-bound text, cheap motion |
| Warm, artisanal, product-led | agrumeafarm | Colored text, serif voice, canvas for one real problem |
| Body of work, catalogue, archive | a24.raviklaassens | Fixed-size WebGL, Lenis, dense real data in an art-directed shell |
| Portfolio, studio, self-aware | paxter | Deliberate plain type, loader as identity, motif in the title |
| Argument, cause, provocation | dontlookup | Interaction as argument, live numbers, human system copy |
| Technical or generative tool | dithergarden | Mono voice, exposed mechanism, output-only color |

When the brief does not match any of them, the through-line at the top of this file still applies: licensed display type, few words, rendered imagery that solves something, a composed entrance, a chosen ground.

---

## Adding to this corpus

When the client sends new references, do not just paste the URL. Open it, read the computed styles for the real font stack and grounds, check `window` for GSAP, ScrollTrigger, Three, Lenis, Barba, count the canvases, videos and images, and write the entry in the same shape: what it is, the table, what to take, what it costs. A reference nobody tore down is decoration.
