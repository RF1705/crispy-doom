#!/usr/bin/env bash
set -euo pipefail

for tool in git python3 make autoconf automake pkg-config ares-package convert; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Missing tool: %s\n' "$tool" >&2
    exit 1
  fi
done

HOST="${WEBOS_HOST:-arm-webos-linux-gnueabi}"
if ! command -v "${HOST}-gcc" >/dev/null 2>&1; then
  echo "Missing webOS TV cross compiler: ${HOST}-gcc" >&2
  echo "Install and activate the webosbrew native SDK (including its environment-setup script)." >&2
  exit 1
fi

if [[ -z "${PKG_CONFIG_SYSROOT_DIR:-}" ]]; then
  echo "WARNING: PKG_CONFIG_SYSROOT_DIR is empty; confirm the webOS native SDK environment is activated." >&2
fi
echo "Cross compiler: $(command -v "${HOST}-gcc")"
echo "SDK pkg-config: $(command -v pkg-config)"
echo "Preflight passed (does not guarantee SDL2 libraries or linker compatibility)."
