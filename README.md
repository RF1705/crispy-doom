# Crispy Doom for LG webOS TV

Experimental native webOS packaging for [Crispy Doom](https://github.com/fabiangreffrath/crispy-doom).

**Project layout:** This repository contains only the webOS integration. The actual game engine is checked out from upstream at the pinned Crispy Doom 7.2 release commit, rather than vendoring Chocolate Doom or maintaining two competing engine source trees.

## Origins

- Engine: [fabiangreffrath/crispy-doom](https://github.com/fabiangreffrath/crispy-doom), commit `fdeabe4c23a833534b70aa84a22f1685aae7125d`
- webOS build concepts and Back-key SDL hint: [webosbrew/chocolate-doom](https://github.com/webosbrew/chocolate-doom/tree/webos-tv/webos)

## Build (experimental, not yet validated on a TV)

Prerequisites: Linux build host, webOS OSE/TV native cross-compiler and target SDL2 development libraries in the compiler sysroot, Autotools, pkg-config configured for the target, git, make, Python 3, ImageMagick, and `ares-package` from webOS CLI. The native cross-compiler target used by the historic port was `arm-webos-linux-gnueabi`; availability depends on the installed SDK.

```bash
# Provide your *own legally obtained* DOOM1.WAD, DOOM.WAD, DOOM2.WAD
# or a compatible freely redistributable IWAD in webos/wads/.
mkdir -p webos/wads
# copy the IWAD into webos/wads/
make -C webos package
```

Environment overrides: `WEBOS_HOST`, `JOBS`, `VERSION`, `ARCH`. The first build fetches the pinned source; subsequent builds reset the disposable build checkout to that commit.

The binary should be `crispy-doom`, app ID `org.crispydoom.webos`. The resulting IPK is in `webos/build/`. **No native build or hardware test has been performed yet.**

## Why not fork Chocolate Doom?

The original webOS demo is useful as an *integration reference*, not as the engine. We intentionally bring across only the relevant build/package pattern and SDL Back-key integration. We do not bundle copyrighted commercial WAD files.

## Next checks

- Verify that Crispy Doom 7.2 cross-compiles with a real TV SDK and target SDL2 libs.
- Verify `ares-package` output filename and ARM architecture handling.
- Install on TV; verify rendering, audio, controller input, Back key, config/save persistence, and Developer Mode.
- Add CI once native SDK availability and licensing are resolved.

Engine license/attribution: see upstream's [COPYING.md](https://github.com/fabiangreffrath/crispy-doom/blob/master/COPYING.md).
