SHELL:=/usr/bin/env bash

VERSION=0.0.1
URL="https://lofi.cafe/"
define BUILD_FLAGS
-n "Lofi Cafe" \
--internal-urls ".*?" \
--min-width 550 \
--min-height 450 \
--width 670 \
--height 500 \
--app-version ${VERSION} \
--bookmarks-menu bookmarks.json \
-i icon.icns \
--inject killchat.js \
--fast-quit \
--darwin-dark-mode-support
endef

default: help
# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps:  ## Verify build dependencies are installed
	@command -v npm >/dev/null 2>&1 || echo "[!] Missing npm"
	@npm install

.PHONY: clean
clean:  ## Clean build output directory
	rm -rf ./out

.PHONY: build
build: clean check-deps  ## Build app for the current platform
	mkdir ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} \
		./out

.PHONY: install-mac
install-mac: build  ## Build & install to /Applications (for macOS)
	cp -R "./out/Lofi Cafe-darwin-x64/Lofi Cafe.app" /Applications || cp -R "./out/Lofi Cafe-darwin-arm64/Lofi Cafe.app" /Applications
