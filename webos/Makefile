SHELL := /bin/bash
VERSION ?= 0.1.0
APP_ID := org.crispydoom.webos
PKG_DIR := build/package
IPK := build/$(APP_ID)_$(VERSION)_all.ipk

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
	@test -f $(IPK) || { echo "Expected $(IPK) missing. Inspect ares-package output in build/" >&2; exit 1; }
	ares-package --info $(IPK)
	@echo "Packaged: $(IPK)"

install: package
	ares-install $(IPK)

launch:
	ares-launch $(APP_ID)

clean:
	rm -rf build
