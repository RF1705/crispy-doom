SHELL := /bin/bash
VERSION ?= 0.1.0
ARCH ?= arm
APP_ID := org.crispydoom.webos
PKG_DIR := build/package
IPK := build/$(APP_ID)_$(VERSION)_$(ARCH).ipk

.PHONY: all build package install launch clean
all: package

build:
	bash ./build.sh

package: build
	rm -rf $(PKG_DIR)
	mkdir -p $(PKG_DIR)
	sed 's/@VERSION@/$(VERSION)/g' appinfo.json > $(PKG_DIR)/appinfo.json
	cp build/install/bin/crispy-doom $(PKG_DIR)/crispy-doom
	convert build/upstream/data/doom.png -resize 80x80 $(PKG_DIR)/icon.png
	@if ls wads/*.wad wads/*.WAD >/dev/null 2>&1; then \
	  cp wads/*.wad wads/*.WAD $(PKG_DIR)/ 2>/dev/null || true; \
	else \
	  echo "WARNING: no IWAD in webos/wads; the app cannot start a game yet"; \
	fi
	cd build && ares-package package
	@test -f $(IPK) || { echo "Expected package $(IPK) not found; check ares-package output" >&2; exit 1; }

install: package
	ares-install $(IPK)

launch:
	ares-launch $(APP_ID)

clean:
	rm -rf build
