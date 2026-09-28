#!/usr/bin/env bash
# Prepare a fresh Linux machine to run the asset factory.
# Idempotent: safe to run at the start of every session.
#
#   bash pipeline/setup.sh            # default Blender series
#   BLENDER_VERSION=5.2.1 bash pipeline/setup.sh
#
# Nothing here has been executed on Devin's image. The first task that runs it
# must report what actually happened, and this file gets corrected from that report.
set -euo pipefail

BLENDER_VERSION="${BLENDER_VERSION:-5.2.1}"
SERIES="$(echo "$BLENDER_VERSION" | cut -d. -f1-2)"
PREFIX="${PREFIX:-$HOME/.local/blender}"
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
if [ -x "$PREFIX/blender" ]; then
  echo "   already installed at $PREFIX"
else
  mkdir -p "$PREFIX"
  echo "   fetching $URL"
  if ! curl -fsSL --retry 3 -o "/tmp/$TARBALL" "$URL"; then
    echo "   FAILED to download $URL"
    echo "   The version is probably wrong for this machine. List what exists:"
    echo "     curl -s https://download.blender.org/release/ | grep -o 'Blender[0-9.]*'"
    echo "     curl -s https://download.blender.org/release/Blender${SERIES}/ | grep -o 'blender-[0-9.]*-linux-x64.tar.xz'"
    echo "   then rerun with BLENDER_VERSION set, and correct the default in this file."
    exit 1
  fi
  tar -xJf "/tmp/$TARBALL" -C "$PREFIX" --strip-components=1
  rm -f "/tmp/$TARBALL"
fi

export PATH="$PREFIX:$PATH"
echo "   $("$PREFIX/blender" --version 2>/dev/null | head -1)"

echo "== render engines actually available on this machine =="
# This is the check that matters. EEVEE needs a GPU or software GL, which a headless
# cloud machine usually lacks. Cycles on CPU always works. Do not assume, print.
"$PREFIX/blender" --background --python-expr "
import bpy
eng = [i.identifier for i in bpy.types.RenderSettings.bl_rna.properties['engine'].enum_items]
print('ENGINES', eng)
print('CYCLES_PRESENT', 'CYCLES' in eng)
" 2>/dev/null | grep -E "^(ENGINES|CYCLES_PRESENT)" || echo "   blender could not report engines, see the error above"

echo "== node tooling =="
cd "$(dirname "$0")"
if [ -d node_modules ]; then
  echo "   node_modules present"
else
  npm install --silent --no-audit --no-fund
fi
node -e "require('sharp'); console.log('   sharp ok', require('sharp/package.json').version)"

echo
echo "Add this to PATH for the rest of the session:"
echo "  export PATH=\"$PREFIX:\$PATH\""
