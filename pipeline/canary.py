"""Canary scene: the smallest scene that exercises all four traps in
taste-frontend/references/blender-pipeline.md.

It decides nothing about how the object should look. It is a shape, a studio and
an output path, built only from what that reference file documents, so that a
machine can be proved to render at all.

    bash pipeline/render.sh pipeline/canary.py -- --res 512
    bash pipeline/render.sh pipeline/canary.py -- --res 720 --frames 12 --out out/turntable/f
"""

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
scene.view_settings.look = "AgX - Base Contrast"       # exists in 5.2, verified

# --- the object: a POLY curve ring with a bevel_depth tube, as the pulse ring was built
RADIUS, SEGMENTS = 1.6, 64
curve = bpy.data.curves.new("ring", type="CURVE")
curve.dimensions = "3D"
spline = curve.splines.new("POLY")
spline.points.add(SEGMENTS - 1)
for i, point in enumerate(spline.points):
    a = i * 2 * math.pi / SEGMENTS
    point.co = (RADIUS * math.cos(a), RADIUS * math.sin(a), 0.0, 1.0)
spline.use_cyclic_u = True
curve.bevel_depth = 0.18
curve.bevel_resolution = 6

obj = bpy.data.objects.new("ring", curve)
scene.collection.objects.link(obj)
obj.rotation_euler = (math.radians(24), 0, math.radians(-14))   # tipped, reads as a form not a line

mat = bpy.data.materials.new("ring")                   # darker base, metallic 0.92, roughness 0.17
mat.use_nodes = True
bsdf = mat.node_tree.nodes["Principled BSDF"]
bsdf.inputs["Base Color"].default_value = (0.08, 0.09, 0.10, 1.0)
bsdf.inputs["Metallic"].default_value = 0.92
bsdf.inputs["Roughness"].default_value = 0.17
obj.data.materials.append(mat)

# camera: compute the distance, do not eyeball it. 85mm on a 36mm sensor sees ~24 degrees,
# so an object D units across needs roughly D / (2 * tan(12deg)) = D * 2.35 units of distance.
SPAN = 2 * (RADIUS + curve.bevel_depth)
DIST = SPAN * 2.35
HEIGHT = DIST * 0.3
cam_data = bpy.data.cameras.new("cam"); cam_data.lens = 85
cam = bpy.data.objects.new("cam", cam_data); scene.collection.objects.link(cam)
cam.location = (0, -DIST, HEIGHT)
cam.rotation_euler = (math.atan2(DIST, HEIGHT), 0, 0)
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
