# Phase 3: Tokens

Translate `brand/BRAND.md` into `brand/tokens.css` and `brand/tokens.json`. Files, not prose. The site imports the CSS; the client reuses the JSON. Every value traces to a decision in BRAND.md; a value that cannot be explained by the register, the motif or the tone is a default wearing a token's name.

The complete example, and the file layout, are in `brand-folder.md`. This file is about deriving the values.

---

## Colour

**Ground and ink, chosen.** The corpus runs warm cream, warm bone, light grey, or true near-black. Pure `#ffffff` and pure `#000000` are almost always wrong; navy-tinted "dark mode" grey was rejected on this account. Warm off-white for editorial and product briefs; true near-black for cinematic ones.

**One accent, and only one.** Desaturated below 80%. A second accent "for variety" is the fastest route back to generic. The v2 ruleset's Colour Consistency Lock applies: the accent chosen for the hero is the accent in the footer.

**Text can be coloured.** Agrumea sets body copy in deep wine rather than black and it does enormous work. Consider it when the register is warm.

**Dark mode** only when the brand has one. If so, a full second set with its own contrast checking, not an inversion.

## Type

**Display, body, mono.** Three roles. The display face is the voice; it is licensed (Pangram Pangram, Adobe Fonts, custom) or, where licensing is impossible, genuinely characterful and free: Bricolage Grotesque, Gabarito, Familjen Grotesk, Newsreader, Source Serif 4. **Never Inter. Never Fraunces. Never Instrument Serif.** The first is the safe default and the other two are the two LLM-favourite display serifs the base ruleset bans by name; one of them was shipped on this account anyway and refused.

A deliberately plain system stack (Helvetica with Times, as Paxter does) is a legitimate editorial position when the concept supports it. Falling back to a safe face because it is safe is not.

**Scale.** One ratio. 1.25 for controlled and technical, 1.333 for editorial, 1.5 for bold. Display sizes via `clamp()` so the hero headline is two lines on desktop and one on a phone. Negative tracking on display sizes, positive on small caps.

**Weights.** Two or three per family, subset and preloaded. `font-display: swap`.

## Spacing and radius

One spacing scale, 4px or 8px base, used everywhere. Phase 4 never eyeballs a padding value.

One radius system for the whole page: all sharp, all soft, or all pill. Mixed only with a written rule.

## Motion

This is the token category most brands skip and the one that separates a site from a template.

- **Pace:** snappy (100 to 200ms, sharp curves) for technical and precise brands; languid (300 to 500ms, soft curves) for premium and editorial. One choice.
- **Two named curves**, written as custom properties, used everywhere. Not `ease-in-out` by default; that is the no-personality choice.
- **What earns motion:** the things that matter, state changes, the set piece, chapter reveals bound to scroll. Not everything on screen.

The motion personality expands into `brand/motion/MOTION.md`, which also specifies the set piece and the interactive moment. Craft for both: `taste-frontend/references/cinematic-scroll.md` and `interactivity.md`.

## Performance budget

Written into `MOTION.md` before Phase 4 starts, from `performance-budget.md`. A site that is beautiful and slow is a worse version of the generic site it replaced.

---

## One delegation, not three

Earlier versions of this file pointed at three different skills for taste calibration. There is one: **`taste-frontend`**. Its `PREFERENCES.md` carries what this client has actually approved, its corpus carries the standard, and its references carry the proven craft. `design-taste-frontend` is its foundation and is read through it. `animate` is for an isolated component transition that falls outside the documented patterns, and nothing more.
