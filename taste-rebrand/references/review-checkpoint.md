# Phase 5: Review gate

A hard gate. Nothing proceeds to delivery until the client has approved `taste/REVIEW_SUMMARY.md` explicitly. By this point you have been inside the build long enough to be the worst-placed person to see what is wrong with it; the gate exists because of that, not despite it.

---

## The verification pass

All in the browser. Reading the code is not verification, and on this account a claim of verification that had not happened was itself a documented failure. Say plainly what was checked and what was not.

1. **Three widths.** 375, 768, 1280. Every scene looked at on the narrow width, since landscape photographs crop their subject out at portrait ratios and multi-column sections that were never given a collapse rule will show it here.
2. **Console and network.** Zero new errors on every page. Every asset from `brand/` loads.
3. **Scroll at normal speed.** Not slowly. Dropped frames on the set piece, or a page that keeps travelling after the wheel stops, are blockers.
4. **Reduced motion.** Toggle it. Every scene fully legible, the entrance gone, the ambient layers removed from the DOM.
5. **The asset floor, re-counted on the live page.** Distinct real assets, not repeats of the mark.
6. **The interaction.** Actually performed, with pointer and with keyboard.
7. **The `taste-frontend` pre-flight**, every box, honestly.
8. **The pane must be displayed.** If the Browser pane is hidden, the tab paints no frames: animations stay pending, transitions never end, IntersectionObserver never fires, and screenshots freeze on initial states. Check tabs_context first. Verify state through JavaScript (classes, dataset, frame sources), finish animations with document.getAnimations() before a layout screenshot, and verify motion only while the pane is displayed.
9. **Rebrand mode:** every pattern in `taste/AUDIT.md` walked line by line and confirmed fixed, or explicitly scoped out; and the performance budget checked against the baseline measured in Phase 1.

---

## REVIEW_SUMMARY.md

- **What was verified and what was not**, first, plainly
- **Backend and integration changes**, rebrand mode: every file touched that relates to `taste/CONTRACT.md`, each marked preserved or flagged as breaking. If the list is empty, write that it is empty; silence is not confirmation.
- **Audit resolution table**, rebrand mode: the Phase 1 table with a Resolved column.
- **Three screenshots per key scene**, one per width.
- **The asset count** and the interactive moment named.
- **Open items:** known gaps, deliberate cuts, anything wanted a second opinion on. Surfacing uncertainty is the point of the gate.

---

## Presenting it

Give the summary directly, not a file path. Ask one direct question: move to delivery, or fix something first. Do not start Phase 6 without the answer.
