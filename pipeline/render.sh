#!/usr/bin/env bash
# Render a Blender scene script headless, then report what it actually produced.
#
#   bash pipeline/render.sh <scene.py> [-- <args passed to the scene>]
#
# Example, a still first, then the sequence, which is the working method:
#   bash pipeline/render.sh brand/3d/bottle.py -- --state before --res 512
#   bash pipeline/render.sh brand/3d/bottle.py -- --state both --res 1000 --frames 36 --out turntable/f
#
# This wrapper deliberately does not choose the engine or the output path. Those live
# in the scene script, because they are art direction as much as configuration. What it
# does is time the run, list the files, and total the weight, so a report has numbers.
set -uo pipefail

SCENE="${1:-}"
if [ -z "$SCENE" ] || [ ! -f "$SCENE" ]; then
  echo "usage: bash pipeline/render.sh <scene.py> [-- <scene args>]"
  exit 1
fi
shift
[ "${1:-}" = "--" ] && shift

BLENDER="${BLENDER:-$HOME/.local/blender/blender}"
if [ ! -x "$BLENDER" ]; then
  if command -v blender >/dev/null 2>&1; then BLENDER="$(command -v blender)"; else
    echo "blender not found. run: bash pipeline/setup.sh"; exit 1
  fi
fi

SCENE_DIR="$(cd "$(dirname "$SCENE")" && pwd)"
BEFORE="$(mktemp)"
find "$SCENE_DIR" -type f \( -name '*.webp' -o -name '*.png' -o -name '*.jpg' -o -name '*.glb' \) 2>/dev/null | sort > "$BEFORE"

echo "== rendering $(basename "$SCENE") =="
START=$(date +%s)
set +e
"$BLENDER" --background --python "$SCENE" -- "$@" 2>&1 \
  | grep -viE "^(Blender [0-9]|Read prefs|found bundled|Warning: |Fra:.*Mem.*Time)" \
  | tail -40
STATUS=${PIPESTATUS[0]}
set -e
ELAPSED=$(( $(date +%s) - START ))

echo
if [ "$STATUS" -ne 0 ]; then
  echo "FAILED after ${ELAPSED}s, exit $STATUS"
  echo "If the error mentions GL, EGL or a display, this machine has no GPU:"
  echo "  the scene is asking for EEVEE. Switch it to CYCLES, which renders on CPU."
  rm -f "$BEFORE"
  exit "$STATUS"
fi

AFTER="$(mktemp)"
find "$SCENE_DIR" -type f \( -name '*.webp' -o -name '*.png' -o -name '*.jpg' -o -name '*.glb' \) 2>/dev/null | sort > "$AFTER"
NEW="$(comm -13 "$BEFORE" "$AFTER")"
rm -f "$BEFORE" "$AFTER"

COUNT=$(printf '%s\n' "$NEW" | grep -c . || true)
echo "== produced $COUNT file(s) in ${ELAPSED}s =="
if [ "$COUNT" -eq 0 ]; then
  echo "Nothing was written, and Blender still reported success."
  echo "That is the relative path trap: Blender resolves render.filepath against the"
  echo "blend file, and a headless factory reset session has none. The scene must call"
  echo "os.path.abspath on its output path. See taste-frontend/references/blender-pipeline.md"
  exit 1
fi

printf '%s\n' "$NEW" | head -8 | while read -r f; do
  [ -n "$f" ] && printf "   %8s  %s\n" "$(du -h "$f" | cut -f1)" "${f#"$SCENE_DIR"/}"
done
[ "$COUNT" -gt 8 ] && echo "   ... and $((COUNT - 8)) more"

TOTAL=$(printf '%s\n' "$NEW" | grep . | xargs -r du -cb 2>/dev/null | tail -1 | cut -f1)
echo "   total $(( ${TOTAL:-0} / 1024 )) KB"
echo
echo "Set piece budget is 5MB. A frame sequence above it becomes a scrubbed video."
