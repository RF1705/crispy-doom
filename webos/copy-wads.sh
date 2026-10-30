#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:?Usage: copy-wads.sh <package-dir>}"
mkdir -p "$TARGET"
shopt -s nullglob nocaseglob
wads=(wads/*.wad)
if (( ${#wads[@]} == 0 )); then
  echo "WARNING: no IWAD in webos/wads; package will need user-provided data"
  exit 0
fi
for wad in "${wads[@]}"; do
  cp -- "$wad" "$TARGET/"
done
echo "Copied ${#wads[@]} WAD file(s)"
