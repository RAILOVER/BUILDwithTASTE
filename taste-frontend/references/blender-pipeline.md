# Blender pipeline

Blender is the answer when a brief needs an object that does not exist as a photograph: an extruded logo, an abstract brand form, a turntable the visitor can drag. It is **not** the answer for recreating a client's physical product, which they already own and can photograph.

## Why this is allowed where hand-drawn SVG was not

Identity artwork is never hand-authored as path coordinates, because writing `M20,8 L20,52` has no visual feedback loop. Blender is different in exactly the way that matters: **a script renders to a PNG, the PNG gets opened and looked at, the script gets adjusted.** The loop is real, so the work is directed rather than guessed.

That loop is mandatory, not optional. Never hand over a render nobody looked at.

---

## Driving it

Blender ships Python and runs headless. No API or connector is needed, only the binary on PATH.

```bash
blender --background --python scene.py -- --out render.png --frames 36
```

Everything after the bare `--` is passed to the script rather than eaten by Blender, so read arguments like this:

```python
import sys, bpy
argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
```

On Windows the installer does not add Blender to PATH, which does not matter: call it by full path, typically `C:\Program Files\Blender Foundation\Blender <ver>\blender.exe`.

### Four traps, all hit on the first real run

**1. Relative render paths fail silently.** Blender resolves `scene.render.filepath` against the .blend file, and a headless factory-reset session has none. It reports success and writes nothing. Always absolutize:

```python
OUT = os.path.abspath(arg("--out", "out/still.png"))
```

**2. Enum names are version-specific.** Blender 5.2 LTS uses `BLENDER_EEVEE`, not the `BLENDER_EEVEE_NEXT` introduced in 4.2. Same for colour looks: `AgX - Medium Contrast` does not exist in 5.2, `AgX - Base Contrast` does. Print the valid values instead of guessing:

```bash
blender --background --python-expr "import bpy; print(bpy.app.version_string); \
print([i.identifier for i in bpy.types.RenderSettings.bl_rna.properties['engine'].enum_items])"
```

**3. Render sequences as WEBP, not PNG.** A 36 frame turntable at 720px came to **6.3MB as PNG and 576KB as WebP**, an 11x saving with no visible loss on flat-shaded geometry, and WebP keeps the alpha. Set `image_settings.file_format = "WEBP"` and `quality = 88`. Note that Blender appends the extension itself, so the filepath must not carry one.

**4. Startup dominates, so batch.** Four frames took 38 seconds, thirty-six took 144. Almost all of the first number is process start and shader compilation. Never loop Blender once per frame from the shell.

---

## Scene template

This is the skeleton of the script that produced the accepted pulse-ring object, with every trap above already applied. Start from it rather than from memory; an earlier version of this template contradicted the traps it sat beneath and would not have run.

```python
import bpy, math, sys, os

# args after the bare "--" belong to the script
argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
def arg(flag, default, cast=str):
    return cast(argv[argv.index(flag) + 1]) if flag in argv else default

os.chdir(os.path.dirname(os.path.abspath(__file__)))
OUT    = os.path.abspath(arg("--out", "out/still"))    # absolute, no extension (trap 1, trap 3)
RES    = arg("--res", 512, int)
FRAMES = arg("--frames", 0, int)

bpy.ops.wm.read_factory_settings(use_empty=True)       # no default cube
scene = bpy.context.scene
scene.render.engine = "BLENDER_EEVEE"                  # 5.2 LTS enum, verified (trap 2)
scene.render.resolution_x = scene.render.resolution_y = RES
scene.render.film_transparent = True                   # alpha, drops onto any ground
scene.render.image_settings.file_format = "WEBP"       # 11x smaller than PNG, keeps alpha (trap 3)
scene.render.image_settings.color_mode = "RGBA"
scene.render.image_settings.quality = 88
scene.view_settings.look = "AgX - Base Contrast"       # exists in 5.2; print the enum if unsure

# --- the object goes here; the pulse ring built a POLY curve with a bevel_depth tube ---
obj = ...                                              # whatever the brief needs
obj.rotation_euler = (math.radians(24), 0, math.radians(-14))   # tipped, reads as a form not a line

# camera: compute the distance, do not eyeball it. 85mm on a 36mm sensor sees ~24 degrees,
# so an object D units across needs roughly D / (2 * tan(12deg)) = D * 2.35 units of distance.
cam_data = bpy.data.cameras.new("cam"); cam_data.lens = 85
cam = bpy.data.objects.new("cam", cam_data); scene.collection.objects.link(cam)
cam.location = (0, -15.0, 4.5)
cam.rotation_euler = (math.radians(73), 0, 0)
scene.camera = cam

# one dominant soft key, a weak fill, a rim: same direction as the photographic set
def light(name, energy, size, loc, rot):
    L = bpy.data.lights.new(name, type="AREA"); L.energy, L.size = energy, size
    O = bpy.data.objects.new(name, L); O.location = loc; O.rotation_euler = rot
    scene.collection.objects.link(O)
light("key",  1400, 7, (-5, -5, 5),     (math.radians(52), 0, math.radians(-42)))
light("fill",  220, 9, (6, -3.5, 1.5),  (math.radians(80), 0, math.radians(58)))
light("rim",   420, 5, (2.5, 5.5, 3),   (math.radians(-60), 0, math.radians(20)))

os.makedirs(os.path.dirname(OUT), exist_ok=True)
if FRAMES:
    base = obj.rotation_euler[2]                       # keep the tilt, add the spin to it
    for i in range(FRAMES):
        obj.rotation_euler[2] = base + math.radians(i * 360.0 / FRAMES)
        scene.render.filepath = f"{OUT}_{i:02d}"       # Blender appends .webp itself
        bpy.ops.render.render(write_still=True)
else:
    scene.render.filepath = OUT
    bpy.ops.render.render(write_still=True)
```

Material that read well on the accepted object: darker base colour with metallic at 0.92 and roughness at 0.17. A pale, barely-metallic surface under soft light rendered flat and was rejected.

Keep the lighting direction consistent with the photographic set. A render lit from the other side is the detail that makes a page feel assembled rather than art-directed.

---

## Turntable, the output that matters most

This feeds the drag-scrub interaction in `interactivity.md`. Rotate the **object**, not the camera, so the light stays fixed and the form reads as turning under a steady source. Add the spin to the object's existing rotation rather than replacing it, or the tilt that made the still read is lost on frame one.

Measured on the accepted object: **36 frames at 720px, 576KB as WebP, 6.3MB as PNG.** Render WebP. At 1280px expect roughly 1.5 to 2MB as WebP, still under the set-piece budget; as PNG it would blow through it.

---

## Exporting for real 3D

When the target is a client site that can load Three.js rather than a CSP-restricted Artifact:

```python
bpy.ops.export_scene.gltf(
    filepath=out_path,
    export_format='GLB',                      # single self-contained file, textures embedded
    export_apply=True,                        # bake modifiers, otherwise the web sees raw geometry
    export_draco_mesh_compression_enable=True,
)
```

Keep it light: a brand object should be a few thousand triangles, not a few hundred thousand. Decimate before exporting if a generated mesh came in heavy.

---

## What to build, and what not to

**Good fits.** Extruded logos and wordmarks, abstract brand forms, geometric primitives arranged with intent, packaging silhouettes, type set in 3D, anything procedural where a loop over parameters is the natural description.

**Bad fits.** A client's actual product, which is faster and more accurate to photograph. Anything organic. Anything needing a modelling session rather than a script. Anything on a deadline the first time it is attempted.

**The middle case.** A generated mesh from a Tripo-class tool, imported and cleaned up in Blender. This is the documented professional pipeline and it beats either half alone.

---

## Working method

1. Write the scene script.
2. Render a single frame at low resolution, 512 is enough.
3. **Open the image and look at it.** Framing, lighting direction, whether the silhouette reads.
4. Adjust and repeat. Three or four passes is normal.
5. Only once a still is right, render the full turntable at final resolution.

Rendering 36 frames of a composition nobody has checked is the main way to waste time here.

### What the loop actually caught, on a real object

Worth recording, because none of it was predictable from the script and all of it was obvious in the render:

- **Pass one: the object overflowed the frame.** An 85mm lens on a 36mm sensor sees about 24 degrees, so an object 4 units across needs roughly 14 units of distance, not 8.5. Compute the framing rather than eyeballing it.
- **Pass one: the feature was invisible.** The waveform spike deviated perpendicular to the ring, which meant it pointed straight at the camera and vanished. Making it deviate **radially**, in the plane of the ring, made it read instantly. A form's signature detail has to be visible in silhouette.
- **Pass two: the material rendered flat.** A pale, barely-metallic surface under soft light has almost no shading variation. Darker base colour plus high metallic gave it depth.
- **Pass two: the feature sat at the far left.** Rotating it upper-right, where the eye lands first, made the whole composition settle.

Three passes, each one a fix that a person would have spotted in a second and a script would never surface on its own.
