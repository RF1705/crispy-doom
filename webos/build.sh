#!/usr/bin/env bash
set -euo pipefail
WEBOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${WEBOS_DIR}/build"
SOURCE="${ROOT}/upstream"
PREFIX="${ROOT}/install"
UPSTREAM_COMMIT="fdeabe4c23a833534b70aa84a22f1685aae7125d"
HOST="${WEBOS_HOST:-arm-webos-linux-gnueabi}"

command -v git >/dev/null
command -v python3 >/dev/null
command -v make >/dev/null

mkdir -p "${ROOT}"
if [[ ! -d "${SOURCE}/.git" ]]; then
  git clone --no-checkout https://github.com/fabiangreffrath/crispy-doom.git "${SOURCE}"
fi
git -C "${SOURCE}" fetch --depth 1 origin "${UPSTREAM_COMMIT}"
git -C "${SOURCE}" checkout --detach --force "${UPSTREAM_COMMIT}"
git -C "${SOURCE}" clean -fdx

# SDL video initialization differs from the older Chocolate Doom port;
# set the webOS Back-button access hint before SDL initializes its video driver.
python3 - "${SOURCE}/src/i_video.c" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text()
needle = "    if (SDL_Init(SDL_INIT_VIDEO) < 0)"
if text.count(needle) != 1:
    raise SystemExit("Unexpected SDL init layout; inspect the upstream revision")
text = text.replace(needle, '    SDL_SetHint("SDL_WEBOS_ACCESS_POLICY_KEYS_BACK", "true");\n' + needle, 1)
path.write_text(text)
PY

mkdir -p "${PREFIX}"
cd "${SOURCE}"
./autogen.sh --host="${HOST}" --prefix="${PREFIX}" \
  --without-libsamplerate --disable-doc --disable-bash-completion
make -j "${JOBS:-2}"
make install
test -x "${PREFIX}/bin/crispy-doom"
echo "Built: ${PREFIX}/bin/crispy-doom"
