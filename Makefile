SHELL:=/usr/bin/env bash

VERSION=1.0.2
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
--inject killchat.js \
--fast-quit \
--darwin-dark-mode-support \
-i icon.icns
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
	mkdir -p ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} ./out

.PHONY: build-all
build-all: clean check-deps  ## Build app for many supported platforms
	mkdir -p ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -p mac -a x64 ./out
	pushd "./out/Lofi Cafe-darwin-x64" &&  zip -r ../lofi-cafe-${VERSION}-macos-x64.zip "./Lofi Cafe.app" && popd
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -p mac -a arm64 ./out
	pushd "./out/Lofi Cafe-darwin-arm64" &&  zip -r ../lofi-cafe-${VERSION}-macos-arm.zip "./Lofi Cafe.app" && popd
# 	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -p windows -a x64 ./out/windows-x64
# 	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -p windows -a arm64 ./out/windows-arm

.PHONY: install-mac
install-mac: build  ## Build & install to /Applications (for macOS, x64 or arm)
	cp -R "./out/Lofi Cafe-darwin-x64/Lofi Cafe.app" /Applications || cp -R "./out/Lofi Cafe-darwin-arm64/Lofi Cafe.app" /Applications
	rm -rf ./out
