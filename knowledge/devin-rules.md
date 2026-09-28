# Rules for the knowledge base

Paste these into Devin's knowledge base. They are short and imperative on purpose: a knowledge base works on rules an agent can check itself against, not on prose.

Every one of them exists because something was shipped and rejected. The long form, with the reactions quoted, is in `taste-frontend/references/PREFERENCES.md`.

## Absolute

- Never use an em dash or an en dash. Run `node check.js` to confirm.
- Never hand author identity artwork as SVG path coordinates. Marks and lettering go to an image model. Objects go to Blender.
- Never keep a generated image without opening it and looking at it. If you cannot look, say so in the report.
- Never delegate to a skill that is not installed in the environment. It fails silently and produces nothing.
- Never decide how something should look. Direction belongs to the person.

## Design defaults, when a task touches a build

- The page is full bleed. The viewport is the canvas. No boxed layout on cinematic work.
- No Google Fonts default as a display face. Fraunces and Instrument Serif are banned by name. Inter is discouraged.
- No button shaped like a button in the interface font. Any action is built from the page's own materials.
- Numbers the page argues for are display moments in the display face with tabular figures, never interface text.
- The identity mark is the subject where it appears. Roughly 140px tall in a reveal, 50 to 60px in navigation.
- No visible bounding box on composited artwork. Scope correction filters to the element that needs them, never a shared class.
- Motion fires on scroll, never on page load.
- A section that plays one reveal and freezes reads as dead. Scrolling surfaces carry continuous low amplitude motion.
- Never hand roll a smooth scroll. Real Lenis where it loads, native scroll otherwise. Windows already smooths wheel input, so a lerp on top double smooths.
- Exactly one scroll scrubbed set piece per page, media under 5MB. Everything else on the cheap tiers.
- Exactly one interactive moment, and it performs the product's actual claim.
- Reduced motion collapses everything to a static legible state, with canvases removed from the DOM rather than hidden.

## Substance

- The asset floor is eight distinct real assets on a brand page, counted not estimated. Distinct means different subject matter.
- When a page feels flat, check the asset count before touching the easing. Several rounds were once spent on motion for a page that had nothing in it.
- The `brand/` folder is finished before the site starts.

## Verification

- A hidden browser pane paints no frames. Animations hold on their first keyframe, transitions never end, IntersectionObserver never fires, and screenshots freeze. Verify state through JavaScript, and verify motion only while the pane is displayed.
- Test scroll at normal speed, not slowly.
- Check three widths: 375, 768, 1280. Look at every scene at the narrow one.

## Technical traps that cost real time

- Blender resolves a relative render path against the blend file. A headless factory reset session has none, so it reports success and writes nothing. Always absolutize.
- Blender appends the file extension itself. The filepath must not carry one.
- Blender enum names are version specific. Print the valid values rather than guessing.
- Render sequences as WebP, not PNG. Measured: 36 frames at 720px came to 6.3MB as PNG and 576KB as WebP.
- Blender startup dominates a short job. Four frames took 38 seconds and thirty six took 144. Never loop the binary once per frame.
- On Windows, a stale real folder in the skills directory silently shadows a junction. Check for JUNCTION, not for the folder.
