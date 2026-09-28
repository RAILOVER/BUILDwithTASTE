# Client taste law

This file is the standing brief. It is not general design advice, it is one person's taste, learned from real production rounds where work was accepted or rejected out loud. Read it before Phase 2 of any build and again at pre-flight. When it conflicts with a generic rule elsewhere, this file wins; when the client says something new that contradicts it, the client wins and this file gets updated.

Everything below was earned, not guessed. The quoted reactions are real.

---

## Part 1: Hard refusals

Each of these was actually shipped once and actually rejected. Do not re-litigate them.

### A wordmark is not a logo
Setting the company name in a nicer typeface and adding a color is not an identity. Rejected verbatim: *"mettre le nom de l'entreprise en changeant le font et en mettant des couleurs n'apporte rien au storytelling de la marque ou a l'identite."*

The bar is a mark that means something without the name attached, the way a bitten apple does. Reduce to initials or an abstract form, fuse the letters into one shape rather than setting them side by side, and let the mark carry the concept. If the name has to be readable for the mark to work, the mark is not finished.

**Scoped exception, 2026-09-18.** For TASTE's own identity the client asked for a wordmark in the fashion-house tradition: *"Pour le logo je veux qui ai ecrit TASTE. dans un style graphique sobre mais tres fashion style Dior, Yves Saint Laurent."* In couture the wordmark is the mark, so for briefs that sit explicitly in fashion a typeset wordmark is accepted. The refusal stands for every product brief that is not.

### Never hand-draw a logo in SVG path coordinates
Plotting `M20,8 L20,52...` by hand and hoping it reads as a letterform produced the single worst result of the entire engagement. There is no visual feedback loop when writing coordinates, so the output is a guess. Logos, marks, and any figurative or lettered artwork go to an image generator (see `asset-generation.md`). Hand-authored SVG is fine for pure geometry the layout depends on (a rule, a wipe mask, a sparkline path), never for identity artwork.

### Button-shaped buttons with default typography
Rejected twice, in escalating terms: *"le bouton start free est tout ce qu'on veut pas... la font est vraiment generique le bouton fait vraiment pas qu'un avec le site il n'apporte rien visuellement"*, then *"toujours immonde j'aime pas du tout."*

What finally worked was deleting the button entirely. A presentation surface does not need a call to action just because landing pages usually have one. When an action genuinely is needed, it must be built from the page's own materials: same type family as the data, same corner language as the panels, and any motion on it borrowed from the page's motif rather than a generic hover-brighten. A filled pill in the default UI font is never the answer.

### Numbers set in the interface font
*"on dirait juste qu'on a incorpore des chiffres en arial sur le site."* Any number the page actually argues for is a display moment, not UI text. What was accepted: the display serif at roughly 38px, `font-variant-numeric: tabular-nums`, a small motif-derived sparkline ahead of each value, the number as the largest element in its container. Reaction: *"c'est BEAUCOUP mieux ca je valide."*

### Logos sized like icons
Raised three separate times before it was right. The identity mark is the subject during any moment it appears, not a 22px garnish beside the real content. In a cold-open or reveal moment expect roughly 140px tall; in navigation expect 50-60px, not 30. When in doubt it is too small.

### Visible bounding boxes on cut-out artwork
A generated mark composited onto a dark ground showed a faintly lighter rectangle where its background sat. Any raster artwork placed on the page ground must be genuinely keyed out. If the generator will not produce a clean ground (SD3 adds a canvas texture no matter what the prompt says), crush it with a contrast filter and scope that filter to the mark only, never to a shared class that also carries photographic or line artwork, which is exactly how the main animation got visibly pixelated.

### Layout that does not sit inside its own frame
Two real failures: a section header where three children were dropped into a two-column grid so the third silently wrapped into the narrow column and read as *"une font bizarre... ca match pas"*, and a chapter whose last line of body copy sat on the divider rule beneath it. Before shipping any section, confirm every child lands where the grid says it should and nothing touches a boundary.

### Motion that fires on page load instead of on scroll
Entrance animation belongs to the moment an element is reached, not to the moment the document parses.

### Sections that hold still
A section that plays one reveal and then freezes reads as dead. Scrolling surfaces want continuous ambient motion for as long as they are on screen, at a low enough amplitude to never compete with reading.

### Browser jank
The reference site the client admires most stutters, and that is named as its one flaw: *"l'animation est un peu trop lourde a mon gout pcq ca fait bug le navigateur... si y'avait pas de bug ce serait vraiment le parfait parfait exemple."* Matching its beauty while staying smooth is the explicit target. A technique that drops frames gets simplified, never shipped as ambition.

### Inventing a direction instead of executing the stated one
The hardest failure of the engagement: a stated vision was replaced with a different idea that was defensible in the abstract and completely wrong. *"c'est vraiment ignoble je voyais pas du tout ca comme ca."* When the client describes a sequence, build that sequence. Improve inside it, do not substitute for it.

### A page whose only imagery is line art
The single largest finding of the gap audit. The reference corpus carries between 12 and 588 photographic or rendered assets each; the rejected build carried two line drawings. Those sites are frames around beautiful subject matter, and a beautiful frame around nothing is still nothing. See `subject-matter.md` for the asset floor and the intake question that prevents this.

### Google Fonts defaults as a display face, and Fraunces by name
Not one site in the client's corpus uses a Google Fonts default. They license: Pangram Pangram, Adobe Fonts, custom faces. Type is the most consistent single signal separating those pages from ordinary ones. The rejected build loaded five Google faces and used **Fraunces**, which the underlying v2 ruleset bans by name as one of the two LLM-favourite display serifs. Refused going forward.

### Boxed layouts on cinematic work
The rejected build rendered inside a fake browser chrome at 1040px. Every corpus site is full bleed. Scale is a large part of why they read as cinematic and a contained layout reads as a slide.

### Hand-rolled smooth scroll, on this client's Windows machine
Rejected twice, at two different settings: *"le ralentissement est trop prononce, on navigue difficilement dessus"*, then *"toujours trop hardcore"*. The cause is not the constant. Windows already smooths wheel input, so any lerp on top double-smooths and the page becomes hard to steer at every value. Ship native scroll. Lenis itself is fine where it can actually be loaded; a hand-rolled substitute is not. Full reasoning in `cinematic-scroll.md`.

The wider lesson, which generalises past scrolling: **when two calibration passes both fail, stop tuning the constant and question the mechanism.**

### Polishing motion on an empty page
Several rounds went into easing, alignment and logo sizing while the page still had nothing in it. Those rounds could not move the outcome, because the missing thing was never the easing. When a page feels flat, check the asset count before touching the motion.

---

## Part 2: Validated, reuse freely

### The cold-open sequence
Accepted as *"NIQUEL"* and *"parfait"*. The shape:

1. Black ground, nothing on screen
2. A motif element draws or wipes across, left to right, once
3. It fades out as the identity mark plus exactly one line of copy fades in together
4. Hold long enough to read, roughly 2.5 seconds
5. Both fade fully to black
6. Next line, loop

Order matters and was corrected once: content must clear the screen completely before the motif wipes again. Never leave the mark sitting static waiting for the next draw.

### Wipe over stroke-draw for raster motion
`clip-path: inset()` animated left to right on a generated raster image reads exactly like a line drawing itself, costs nothing, and avoids the pixelation that filters on a shared class caused.

### A quiet menu for the impatient
A cold open that reveals one idea at a time needs an escape hatch: a plain text trigger top right opening a short list of the same sections, jumping straight there. No information is hidden behind the pacing, the pacing is just the default path.

### Scroll-triggered reveals via IntersectionObserver plus CSS transitions
Cheap, smooth, respects reduced motion trivially.

### Generated assets over drawn ones
The generated mark and the generated ECG line were both immediately better than anything hand-plotted. Generate, then integrate.

---

## Part 3: The house look

Derived from the client's own reference corpus (see `reference-corpus.md`). These are defaults, not laws, but departing from them needs a reason.

**Typography carries everything.** Every site in the corpus uses licensed display faces, none uses a Google Fonts default. Reach for PP Neue Montreal, PP Eiko, PP Museum, ivystyle-sans, ivymode or similar. Where a project cannot license one, pick a free face with genuine character (Bricolage Grotesque, Gabarito, Familjen Grotesk, Newsreader, Source Serif 4) and never Inter, never Fraunces, never Instrument Serif. A deliberately plain system stack (Helvetica with Times, as Paxter does) is a legitimate editorial move; falling back to a safe default because it is safe is not.

**Full bleed.** The viewport is the canvas. Imagery runs to the edges, type is set large, one idea holds a screen. Contained widths are for running body copy only.

**Smooth scroll, only the real thing.** Lenis where it can be loaded, initialised once at the root; A24 runs it and it is part of why that page feels unlike an ordinary site. Where it cannot be loaded, native scroll. Never a hand-rolled substitute; see Part 1.

**A composed entrance.** A loader or a counter, even brief. Three corpus sites open this way; Paxter's is `[0%]`, in brackets, matching its own title motif.

**Grounds are chosen, not defaulted.** The corpus runs warm cream, warm off-white, light grey, and true black. Navy-tinted "dark mode" greys were replaced with genuine near-black on request. Pure `#ffffff` and pure `#000000` are both usually wrong; warm off-white or true near-black are usually right.

**Few words per screen.** Agrumea's entire hero is a sentence and two words. A screen holding one idea and a lot of air reads expensive; a screen holding a paragraph reads like a brochure.

**Responsive is verified, not assumed.** Every scene looked at on a phone width before review. Landscape photographs crop their subject out at portrait ratios unless `object-position` was chosen per image, and a multi-column section with no collapse rule shows it immediately.

**Imagery is rendered, not just placed.** A24 draws its entire film library in WebGL; Agrumea renders each jar's curved label on its own 2D canvas. Canvas there solves a real problem rather than adding spectacle, which is the standard to hold.

**Loading is part of the experience.** Several corpus sites open on a counter or a deliberate loader. A considered entrance beats a page that pops in half-rendered.

---

## Part 4: How to work on this account

**Confirm the shape before building the whole thing.** A misread vision costs a full rebuild. When the client describes something specific, restate it in one sentence and build that.

**Show, do not describe.** Judgment happens on the artifact, never on a written plan.

**Conduct, do not paint.** The client's own framing: *"laisse la generation d'images a l'api competente car tu n'arrive pas bien a generer des images, je te vois plus en chef d'orchestre."* Write the strategy, the prompts, the scripts and the code; direct the image model and Blender; judge every output by looking at it. Never author a mark, an illustration or any lettered artwork by hand.

**Report honestly.** Say what was verified and what was not. If the browser could not be checked, say so rather than implying it was.

**Fork decisions go to the client.** Choosing between two genuinely different directions is their call. Choosing an easing curve is not.

**Keep this file current.** New verdicts land here, in the client's own words where possible.
