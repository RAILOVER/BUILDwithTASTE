# Asset generation

Identity artwork does not get hand-authored as SVG path coordinates. Writing `M20,8 L20,52...` and hoping it reads as a letterform has no visual feedback loop, and it produced the worst output of the engagement. Generate it, look at it, integrate it.

The division of labour that works: the image model makes the artwork, the agent does the direction, the correction, the compositing and the motion.

---

## Which generator

Settled by measurement in September 2026, not by reputation. The headline finding overturned an earlier assumption in this file, so trust the table over any general claim about which model is "better".

**The split that matters: SD3 Medium is weak at lettering and strong at photography.** Those were being treated as one capability. They are not. The logo failures that cost several rounds were lettering failures. On photographic still life, the same model produced work genuinely comparable to the corpus references on the first attempt.

Since photography is where the asset floor lives, and lettering is one or two marks per project, the free route covers the large half.

| Route | Cost | Quality | Use for |
|---|---|---|---|
| **SD3 Medium** via `hf-inference` | Free, no card, held 5/5 in a burst test and 10+ across a session | Excellent on photographic still life, texture, atmosphere. Poor at lettering. Ignores background colour, always adds a canvas grain. | **The volume.** Photography, texture, ambience, everything the asset floor counts. |
| **FLUX.1 schnell / dev** via HF provider routes | Free credits **exhausted after two images**, then hard-stops | Clearly the best of the free options, including much better composition and prop staging | The one or two shots that have to be exceptional, budgeted at two a month. |
| **Pollinations** (`image.pollinations.ai`, no key) | Free, unlimited, no auth | Below SD3, softer and less controlled, **and it watermarks** despite `nologo=true` | Rough thumbnails only. Not for delivery. |
| **Nano Banana** (Gemini image) | Needs billing attached before the image free tier unlocks | Best at instruction following, lettering, clean grounds | Lettering and marks, once the client attaches billing. |

### The working free workflow

1. **Everything photographic: SD3 on `hf-inference`.** This is most of the asset floor and it is genuinely free at volume.

```bash
KEY=$(cat "$SCRATCH/.hf_api_key")
curl -s -o out.jpg \
  "https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-3-medium-diffusers" \
  -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -X POST -d '{"inputs":"<prompt>"}'
```

Returns image bytes directly. A JSON body instead means an error; read it. Note the host: the old `api-inference.huggingface.co` no longer resolves.

2. **The hero shot, up to twice a month: FLUX via the provider route.** The URL shape is not the model id, it is `router.huggingface.co/<provider>/<providerId>`, and the payload key is `prompt`, not `inputs`. It answers with a JSON URL, not bytes.

```bash
curl -s "https://router.huggingface.co/fal-ai/fal-ai/flux/schnell" \
  -H "Authorization: Bearer $KEY" -H "Content-Type: application/json" \
  -d '{"prompt":"<prompt>","image_size":"landscape_4_3"}'
# -> {"images":[{"url":"https://..."}]}   then curl that url
```

Find the right `providerId` for any model from its metadata rather than guessing:

```bash
curl -s "https://huggingface.co/api/models/<org>/<model>?expand[]=inferenceProviderMapping"
```

`FLUX.1-schnell` and `FLUX.1-dev` are served by fal-ai, wavespeed and nscale; the plain `hf-inference` route returns **410 Gone** for all of them, which is why they look unavailable at first.

3. **Lettering and marks.** SD3 will not do this well. Spend a FLUX credit, or hand it to the client to generate in Gemini's app or Ideogram and pass the file back. Do not burn four rounds on SD3 attempts, which is what happened before this was understood.

### Escalating to Nano Banana

Worth doing when the client is ready, because it removes the three defects that cost the most time: it honours a stated background colour, it sets real letterforms, and it leaves clean grounds. A fresh Google Cloud project returns `free_tier_requests, limit: 0` on image models even though text works; Google gates the image free tier behind a billing account being attached, without charging inside the quota. That is the client's call on their own account.

Auth for the newer `AQ.`-prefixed keys is a header, not a query parameter, and model ids move (`gemini-2.0-flash` is already retired and 404s with its replacement named in the error):

```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/<image-model>:generateContent" \
  -H "x-goog-api-key: $KEY" -H "Content-Type: application/json" \
  -X POST -d '{"contents":[{"parts":[{"text":"<prompt>"}]}]}'
```

---

## What this model actually does

Learned by watching it, not by reading its docs.

**It responds to "logotype", not to "monogram".** Asking for a *"minimalist geometric monogram logo, letters P and B fused"* produced one ambiguous letterform with artefacts. Asking for a *"logotype design, two geometric sans-serif letters P and B sharing one shared vertical stroke"* produced a clean, readable, genuinely fused mark. Naming the construction ("sharing one shared vertical stroke") is what anchors it.

**It ignores background colour instructions.** Asked twice for black ground, returned white ground both times. Do not fight this; fix it in CSS.

**It always adds a canvas or paper texture.** Explicitly prompting *"no texture, no grain, no paper texture, no canvas texture, smooth flat color"* did not remove it. This is a model bias, not a prompt failure, and it is the cause of the faint rectangle that shows when a mark is composited onto a dark ground.

**Line art is its strength.** A single-line ECG waveform came back elegant on the first attempt, better than anything plotted by hand.

---

## Correcting what comes back

**Inverting to white-on-black, and killing the texture.** Crush the texture into true black with contrast, then let the black fall out against the page ground.

```css
.mark {
  filter: invert(1) contrast(500%);
  mix-blend-mode: screen;
}
```

**Scope that filter to the elements that need it.** This caused a real regression: putting the aggressive contrast on a shared class also hit a photographic line drawing using the same class, and the main animation visibly pixelated. Name the specific usages.

```css
.logo-mark .mark,
.reveal .mark,
.footer .mark { filter: invert(1) contrast(500%); }   /* flat lettering */
.ambient .mark { filter: invert(1); }                  /* line art, no crush */
```

**Background removal models** are mostly unavailable on the free inference route (`briaai/RMBG-1.4` returns "Model not supported by provider"). The contrast trick is the practical answer.

---

## Embedding

Inline as a data URI so the artifact stays self-contained. Do not pipe a large base64 string through tool calls; write a small script and let it do the substitution on disk.

```bash
base64 -w 0 asset.png > asset.b64
```

```js
// inject.js, run as: node inject.js index.html asset.b64   (then delete it)
const fs = require('fs');
const f = process.argv[2] || 'index.html';                 // the page
const b64 = process.argv[3] || 'asset.b64';                // the base64 file from the step above
const html = fs.readFileSync(f, 'utf8');
const uri = 'data:image/png;base64,' + fs.readFileSync(b64, 'utf8').trim();
const before = html.split('__PLACEHOLDER__').length - 1;
const out = html.split('__PLACEHOLDER__').join(uri);
fs.writeFileSync(f, out);
console.log(`replaced ${before}, remaining ${(out.match(/__PLACEHOLDER__/g) || []).length}`);
```

Put `__PLACEHOLDER__` everywhere the asset appears. The script prints how many it replaced and how many remain; the second number must be zero.

**Before publishing:** always look at the generated image with the Read tool. It is the only way to know whether it worked, and the client's judgment will be visual. Never integrate an asset sight unseen.

---

## Prompt patterns that worked

**Fused letter mark**
> logotype design, two geometric sans-serif letters P and B sharing one shared vertical stroke, solid flat background, clean vector logo, high contrast black shapes

Swap the letters and the construction ("sharing one shared vertical stroke", "interlocking counters", "one continuous stroke"). Say `logotype`.

**Single-line motif**
> a single thin continuous black line drawing of an electrocardiogram heartbeat waveform, minimal, elegant, wide horizontal composition, flatline with one clean heartbeat spike in the center, white background, no text, vector line art

Reliable. `single thin continuous line` plus `vector line art` is the combination that holds.

**Abstract mark**
> minimalist logo icon, a single continuous thin line forming [concept], negative space, luxury brand identity, centered, symmetrical

Softer and more variable than the logotype pattern. Generate several.

---

## Library

Assets that were accepted, kept with the prompt that produced them, in `assets/`. Reuse them only for the project they belong to; for a new client, regenerate, because the whole point is that the mark means something specific to that brand.

| File | What | Prompt pattern | Verdict |
|---|---|---|---|
| `pb-monogram.png` | Fused PB letter mark | Fused letter mark, above | Accepted |
| `ecg-line.png` | Three-beat ECG waveform | Single-line motif, above | Accepted |

---

## Generating at volume

The asset floor in `subject-matter.md` means most builds need eight or more distinct assets, not one mark. Plan them as a set, not one at a time.

Write the full asset list before generating anything: what each image shows, where it sits, what shape it needs. Then generate the set in one pass so lighting, grain, palette and framing hold together. A page of individually beautiful images that do not share a treatment looks worse than a page of plainer images that do.

Consistency levers that work across a set: name the same lighting in every prompt ("single soft window light from the left"), the same medium ("35mm film, fine grain"), the same palette, and the same distance ("mid shot, subject centred"). Vary only the subject.

Generations are free on both routes, so overshoot and cut. Ten generated, six kept, is a normal ratio.

## When to escalate past the model

SD3 Medium is weak at precise multi-letter typography and will not honour background colour. Nano Banana covers both. If neither is available and a mark needs exact letterforms, say so plainly and let the client generate it in a tool built for lettering (Ideogram), then hand the file back for integration. Say it rather than shipping a fourth mediocre attempt, which is what happened before this rule existed.
