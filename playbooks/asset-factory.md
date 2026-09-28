# Playbook: the asset factory

Render 3D objects and process image assets, so a live design session never waits on a render.

**Trigger:** a scene script or a batch of raw generated images lands in a client repository.

**You decide nothing here.** Framing, lighting and which image to keep are art direction. You run the machine and report numbers.

## Setup, once per session

```
bash pipeline/setup.sh
export PATH="$HOME/.local/blender:$PATH"
```

It prints which render engines this machine actually has. Read that line before anything else.

**EEVEE needs a GPU or software GL. A headless cloud machine usually has neither.** If the engines list has no usable EEVEE, or a render dies mentioning GL, EGL or a display, the scene must switch to Cycles, which renders on CPU and always works. Cycles is slower and its output is not pixel identical, so say so in the report rather than silently swapping and calling it done.

## The working method, which is not optional

Renders are cheap to get wrong and expensive to repeat. The loop that works:

1. Render **one still at low resolution**, 512 is enough.
2. **Open the image and look at it.** Framing, lighting direction, whether the silhouette reads.
3. Adjust and repeat. Three or four passes is normal.
4. Only once a still is right, render the full sequence at final resolution.

Rendering 36 frames of a composition nobody has checked is the main way to waste a session.

You can open an image. Do it. If for any reason you cannot, stop and say so: an unviewed render must never be committed.

## Rendering

```
bash pipeline/render.sh <scene.py> -- --state before --res 512
bash pipeline/render.sh <scene.py> -- --state both --res 1000 --frames 36 --out turntable/f
```

The wrapper times the run, lists what appeared and totals the weight. Two failures it will name for you:

- **Nothing written, success reported.** Blender resolves a relative render path against the blend file, and a headless factory reset session has none. The scene must absolutize its output path.
- **Doubled extension.** Blender appends the extension itself, so the filepath must not carry one.

Startup dominates a short job. Four frames took 38 seconds and thirty six took 144 on the reference machine, so never loop the binary once per frame.

## Image processing

```
node pipeline/assets.js cutout  raw/mark.jpg brand/logo/mark.png 240
node pipeline/assets.js sheet   review.png 3 300 brand/logo/*.png --bg '#f4f4f2'
node pipeline/assets.js webp    brand/logo/*.png --out site/assets/logos --width 1000
node pipeline/assets.js favicon brand/logo/mark.png site/assets/
```

Build the contact sheet **on the real page ground**, never on white. A white halo is invisible on white, which is how one shipped with a visible box around it.

## Budgets, which are the point of the report

| thing | limit |
|---|---|
| Set piece media | under 5MB, or switch to a scrubbed video |
| Turntable | 36 frames, WebP. Measured: 576KB at 720px, against 6.3MB as PNG |
| Sequence format | always WebP, never PNG |

## What to report back

- Which engine ran, and whether it was the one the scene asked for.
- Seconds elapsed and frames produced.
- Total weight in KB, against the 5MB budget.
- A contact sheet on the page ground, attached.
- Anything you could not verify.

## Definition of done

The files exist, they are WebP, the total is under budget, the contact sheet is attached, and a person has something to look at. Not: the command exited zero.
