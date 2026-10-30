SHELL := /bin/bash
VERSION ?= 0.1.0
APP_ID := org.crispydoom.webos
PKG_DIR := build/package
IPK_GLOB := build/$(APP_ID)_$(VERSION)_*.ipk

.PHONY: all preflight build package install launch clean
all: package

preflight:
	@bash ./preflight.sh

build: preflight
	bash ./build.sh

package: build
	rm -rf $(PKG_DIR)
	mkdir -p $(PKG_DIR)
	sed 's/@VERSION@/$(VERSION)/g' appinfo.json > $(PKG_DIR)/appinfo.json
	install -m 755 build/install/bin/crispy-doom $(PKG_DIR)/crispy-doom
	convert build/upstream/data/doom.png -resize 80x80 $(PKG_DIR)/icon.png
	@bash ./copy-wads.sh "$(PKG_DIR)"
	ares-package --outdir build $(PKG_DIR)
	@ls $(IPK_GLOB) >/dev/null 2>&1 || { echo "IPK missing. Inspect ares-package output in build/" >&2; exit 1; }
	@bash -c 'set -e; files=( $(IPK_GLOB) ); test ${#files[@]} -eq 1 || { echo "Expected exactly one IPK, found ${#files[@]}" >&2; exit 1; }; ares-package --info "${files[0]}"'
	@echo "Packaged: $(IPK_GLOB)"

install: package
	@bash -c 'set -e; files=( $(IPK_GLOB) ); test ${#files[@]} -eq 1; ares-install "${files[0]}"'

launch:
	ares-launch $(APP_ID)

clean:
	rm -rf build
