# Phase 6: Delivery

Three outputs. All three land inside the folders the client keeps.

---

## brand/guidelines.html

The brand guidelines as a designed page, in the folder, so the client owns it outright. Build it with the same care as the site; a generic guidelines page undermines the engagement. If the environment supports publishing an Artifact, publish one as well for easy sharing, but the file in the folder is the deliverable.

Sections, in order:

1. **Story.** The narrative from `BRAND.md` as prose, not bullets. The section a founder reads and forwards.
2. **The mark.** Primary, the keyed variants on light and dark, minimum size, clear space, and explicit misuse: stretched, recoloured, on a low-contrast ground. Show what not to do.
3. **Colour.** Every token from `tokens.css` with its value and its job. The dark set if there is one.
4. **Type.** The three faces at actual size, the scale, and the pairing rationale. Name the licence the client needs to hold.
5. **Voice.** The do/don't table, with real before and after copy pulled from the site build rather than invented.
6. **Imagery.** The treatment string from `imagery/prompts.md`, three or four images from the set, and what to seek out and avoid when adding more.
7. **Motion.** The personality from `MOTION.md`, with the two curves demonstrated live on the page. Motion cannot be conveyed in prose; embed working examples.
8. **The object**, if `3d/` exists: the turntable, embedded and draggable, with the script's name so it can be re-rendered.

Full bleed, `tokens.css` imported, the display face carrying the headings. It should look like a page from the site, because it is one.

---

## Export set

Into `brand/logo/` and `brand/social/`.

**The mark.** Be honest about the format: generation produces raster. Deliver `mark-dark.png` and `mark-light.png` keyed for their grounds, then 512, 256, 128 and 64px on transparent, plus the favicon set: 16, 32, 48, and apple-touch at 180. There is no SVG unless the mark was built as pure geometry in Blender and exported, or the client commissions a vectorisation. Say so in `HANDOFF.md` rather than promising a file that does not exist.

**Social.** Only the platforms the client actually uses. Profile image at each platform's size, cover or banner where one exists, and an og image at 1200 by 630 using the hero asset and the mark. Not a generic pack for every network in existence.

---

## taste/HANDOFF.md

Short. The last thing the client reads.

- What was built, in plain language a non-technical stakeholder can follow
- Where everything lives: `brand/` and what each part is for, the site and how to run it, env var names only, never values
- The licence the type requires, if any
- **Rebrand mode:** explicit confirmation that `taste/CONTRACT.md` held, or the list of approved breaking changes from `REVIEW_SUMMARY.md`
- What was not done and why, if anything was scoped out at review

Not a restatement of every intermediate document. Tight, and confidence-inspiring.
