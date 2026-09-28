# Playbook: verify a finished build

**Trigger:** a site is ready for the review gate.

This closes the studio's weakest link. A build is routinely described as finished when what was actually checked is that the code looks right. This playbook checks the page instead. Full contents: `taste-rebrand/references/review-checkpoint.md`.

## The pass

1. **Three widths.** 375, 768, 1280. Screenshot every scene at each. Look at every scene at the narrow one: a landscape photograph crops its subject out at portrait ratios, and a multi column section with no collapse rule shows it here.
2. **Console and network.** Zero errors on every page. Every asset returns 200, none 404.
3. **Scroll at normal speed**, not slowly. Dropped frames on the set piece, or a page that keeps travelling after the wheel stops, are blockers.
4. **Reduced motion.** Toggle it. Every scene fully legible, the entrance gone, canvases removed from the DOM rather than hidden.
5. **The asset count**, on the live page. Distinct real assets, not repeats of the mark. Floor is eight on a brand page.
6. **The interaction**, actually performed, with a pointer and with the keyboard.
7. **Core Web Vitals** on a throttled mobile profile: LCP under 2.5s, CLS under 0.1, TBT under 200ms.
8. **Total transferred weight**, and the set piece against its 5MB budget.

## The trap that makes this report lie

**A hidden or backgrounded browser pane paints no frames.** Animations hold on their first keyframe, CSS transitions never end, IntersectionObserver never fires, and screenshots come back frozen or one step stale. It looks exactly like a broken site and is not one.

So:

- Verify **state** through JavaScript: class names, dataset values, the current frame source. That is reliable.
- Before a layout screenshot, settle animations with `document.getAnimations().forEach(a => a.finish())`.
- Verify **motion** only while the page is genuinely visible and painting.
- If you cannot confirm motion, say that in the report. Do not infer it from the code.

## Output

`taste/REVIEW_SUMMARY.md`:

- **What was verified and what was not**, first, plainly.
- Three screenshots per key scene, one per width.
- Console, network and vitals numbers.
- Asset count, and the interactive moment named.
- Open items: known gaps, anything you want a second opinion on.

## Definition of done

Every item above has a result, and every unverified item is named as unverified. A report that hides a gap is worse than a short one. You do not pass or fail the build: you hand a person the evidence and they decide.
