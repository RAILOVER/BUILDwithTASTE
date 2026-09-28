#!/usr/bin/env bash
# Prepare a fresh Linux machine to run the asset factory.
# Idempotent: safe to run at the start of every session.
#
#   bash pipeline/setup.sh            # default Blender series
#   BLENDER_VERSION=5.2.1 bash pipeline/setup.sh
#   BLENDER_PREFIX=/opt/blender bash pipeline/setup.sh
#
# Executed on Devin's Ubuntu image on 2026-09-28 with Blender 5.2.1 LTS. The
# engine probe and the node step below are the parts that were corrected from
# that run: see the pull request that added pipeline/canary.py.
set -euo pipefail

BLENDER_VERSION="${BLENDER_VERSION:-5.2.1}"
SERIES="$(echo "$BLENDER_VERSION" | cut -d. -f1-2)"
BLENDER_PREFIX="${BLENDER_PREFIX:-${PREFIX:-$HOME/.local/blender}}"
# nvm refuses to load when PREFIX is set, and the node half of this script needs nvm.
unset PREFIX
TARBALL="blender-${BLENDER_VERSION}-linux-x64.tar.xz"
URL="https://download.blender.org/release/Blender${SERIES}/${TARBALL}"

echo "== system libraries =="
# Blender needs these even with --background. Ignore failures on images that already have them.
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -qq || true
  sudo apt-get install -y -qq --no-install-recommends \
    libx11-6 libxi6 libxxf86vm1 libxfixes3 libxrender1 libgl1 libegl1 libsm6 \
    libxkbcommon0 xz-utils curl ca-certificates >/dev/null 2>&1 || \
    echo "   apt install reported an error, continuing so the Blender check can say what is missing"
fi

echo "== blender =="
if [ -x "$BLENDER_PREFIX/blender" ]; then
  echo "   already installed at $BLENDER_PREFIX"
else
  mkdir -p "$BLENDER_PREFIX"
  echo "   fetching $URL"
  if ! curl -fsSL --retry 3 -o "/tmp/$TARBALL" "$URL"; then
    echo "   FAILED to download $URL"
    echo "   The version is probably wrong for this machine. List what exists:"
    echo "     curl -s https://download.blender.org/release/ | grep -o 'Blender[0-9.]*'"
    echo "     curl -s https://download.blender.org/release/Blender${SERIES}/ | grep -o 'blender-[0-9.]*-linux-x64.tar.xz'"
    echo "   then rerun with BLENDER_VERSION set, and correct the default in this file."
    exit 1
  fi
  tar -xJf "/tmp/$TARBALL" -C "$BLENDER_PREFIX" --strip-components=1
  rm -f "/tmp/$TARBALL"
fi

export PATH="$BLENDER_PREFIX:$PATH"
echo "   $("$BLENDER_PREFIX/blender" --version 2>/dev/null | head -1)"

echo "== render engines actually available on this machine =="
# This is the check that matters. EEVEE needs a GPU or software GL, which a headless
# cloud machine usually lacks. Cycles on CPU always works. Do not assume, print.
#
# Reading the engine enum is not enough: Cycles is an add-on, it is not enabled in a
# --python-expr session, and the enum stays static even once it is, so the enum claims
# BLENDER_EEVEE is the only engine on a machine where CYCLES assigns fine. Enable the
# add-on, then probe by assignment, then render 64 pixels so EEVEE is proved, not assumed.
"$BLENDER_PREFIX/blender" --background --python-expr "
import bpy, addon_utils, tempfile, os
addon_utils.enable('cycles', default_set=True)
r = bpy.context.scene.render
ok = []
for e in ('BLENDER_EEVEE', 'BLENDER_EEVEE_NEXT', 'CYCLES', 'BLENDER_WORKBENCH'):
    try:
        r.engine = e
        ok.append(e)
    except TypeError:
        pass
print('ENGINES', ok)
print('CYCLES_PRESENT', 'CYCLES' in ok)
rendered = False
if 'BLENDER_EEVEE' in ok:
    bpy.ops.wm.read_factory_settings(use_empty=True)
    sc = bpy.context.scene
    sc.render.engine = 'BLENDER_EEVEE'
    sc.render.resolution_x = sc.render.resolution_y = 64
    sc.render.image_settings.file_format = 'WEBP'
    cam = bpy.data.objects.new('cam', bpy.data.cameras.new('cam'))
    sc.collection.objects.link(cam)
    sc.camera = cam
    out = os.path.join(tempfile.mkdtemp(), 'probe')
    sc.render.filepath = out
    try:
        bpy.ops.render.render(write_still=True)
        rendered = os.path.exists(out + '.webp')
    except Exception as exc:
        print('EEVEE_ERROR', exc)
print('EEVEE_RENDERS_HEADLESS', rendered)
" 2>/dev/null | grep -E "^(ENGINES|CYCLES_PRESENT|EEVEE_RENDERS_HEADLESS|EEVEE_ERROR)" || echo "   blender could not report engines, see the error above"

echo "== node tooling =="
cd "$(dirname "$0")"
# node is installed through nvm on Devin's image and nvm is only on PATH in an
# interactive shell, so a bare "npm install" here dies with "npm: command not found".
if ! command -v npm >/dev/null 2>&1 && [ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]; then
  # shellcheck disable=SC1090
  . "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
  echo "   node from nvm: $(node --version 2>/dev/null)"
fi
if ! command -v npm >/dev/null 2>&1; then
  echo "   npm not found. Install node, or run: . \"\$HOME/.nvm/nvm.sh\" before this script."
  exit 1
fi
if [ -d node_modules ]; then
  echo "   node_modules present"
else
  npm install --silent --no-audit --no-fund
fi
node -e "require('sharp'); console.log('   sharp ok', require('sharp/package.json').version)"

echo
echo "Add this to PATH for the rest of the session:"
echo "  export PATH=\"$BLENDER_PREFIX:\$PATH\""
echo "And, for the node half of the factory:"
echo "  . \"\$HOME/.nvm/nvm.sh\""
