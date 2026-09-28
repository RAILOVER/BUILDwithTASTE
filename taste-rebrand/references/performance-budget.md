# Phases 3 to 5: Performance budget

A site that is beautiful and slow is a worse version of the generic site it replaced; the client's users experience latency, not brand identity. This budget exists so "make it feel premium" never quietly becomes "make it heavy." The client's favourite reference stutters, and they have named that as its one flaw; a smooth version of it is the standing target.

## Concrete targets

- **JavaScript.** Rebrand mode: the rebuild's total bundle stays within 15 to 20% of the baseline measured in Phase 1, so there is a number to budget against rather than a feeling. Greenfield mode has no baseline, so the absolute targets below are the budget, and the page ships without a framework unless the brief needs one.
- **Core Web Vitals** on a throttled mobile profile: LCP under 2.5s, CLS under 0.1, TBT under 200ms. Checked in the browser tools before Phase 5, not on an unthrottled desktop.
- **Images.** Every asset from `brand/imagery/` served as WebP or AVIF at the size the layout needs, with `srcset` where a scene spans widths. No unoptimised PNG heroes; the generator's raw output is never shipped as-is.
- **The set piece.** One scroll-scrubbed moment per page, media under 5MB. A turntable is 36 frames as WebP, about 576KB at 720px and 1.5 to 2MB at 1280px. A frame sequence over the budget becomes a scrubbed video. Never a preload gate on hundreds of full-resolution frames; that is the one thing in the reference corpus to leave behind.
- **Fonts.** Subset and preload the display face, two or three weights per family at most, `font-display: swap`.

## Animation library policy

Default to CSS transforms and transitions and the native Web Animations API for anything that can be expressed that way: hover states, reveals, the cold-open sequence, the IntersectionObserver patterns. Zero bundle cost, and it runs on the compositor.

Pull in GSAP or Motion only when the moment genuinely needs it: scroll-linked choreography with scrub, physics springs, a sequence CSS scroll-timeline cannot yet express. When you do, justify it in one line in `brand/motion/MOTION.md`, for example: "GSAP ScrollTrigger drives the pinned scrub in scene 3; scroll-timeline does not support pin plus scrub." A documented decision, not an accumulated habit. Lenis is fine where it loads; a hand-rolled smooth-scroll substitute is refused on this account.

## Lazy-loading rules

- Below-the-fold images: `loading="lazy"`, or the framework equivalent. The hero and the first scene are eager.
- Below-the-fold sections with their own JS (the interactive moment, embedded video, charts): code-split, loaded on viewport entry or first interaction, never in the initial payload.
- Third-party scripts (analytics, chat, embeds): after first paint, never blocking.
- Turntable frames: preloaded once the scene is near, and all of them before the drag is enabled.

## Verifying the budget, Phase 5

In the browser: `read_network_requests` for total transferred weight and request count, the console and `preview_logs` for warnings, then a pass against the targets above at normal scroll speed. A missed target is a Phase 5 blocker. It is fixed before the review goes to the client; "we'll optimise later" never reaches the handoff.
