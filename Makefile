# Based on https://github.com/cdzombak/nativefier-app-template

SHELL:=/usr/bin/env bash

APPNAME="Lofi Cafe"
VERSION:=$(shell [ -z "$$(git tag --points-at HEAD)" ] && echo "$$(git describe --always --long --dirty | sed 's/^v//')" || echo "$$(git tag --points-at HEAD | sed 's/^v//')")
URL="https://lofi.cafe/"
define BUILD_FLAGS
-n ${APPNAME} \
--internal-urls ".*?" \
--min-width 550 \
--min-height 450 \
--width 670 \
--height 500 \
--app-version ${VERSION} \
--bookmarks-menu bookmarks.json \
--inject userscript.js \
--fast-quit \
--darwin-dark-mode-support
endef
define BUILD_FLAGS_MAC
-i icon.icns
endef

default: help
# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps:  ## Verify build-time dependencies are installed
	@command -v npm >/dev/null 2>&1 || echo "[!] Missing npm"
	@npm install

.PHONY: update-deps
update-deps: check-deps  ## Update the application's dependencies (eg. nativefier)
	npm update

.PHONY: clean
clean:  ## Clean build output directory
	rm -rf ./out

.PHONY: build-current-mac
build-current-mac: clean check-deps update-deps  ## Build app for the current macOS platform (Intel or Apple Silicon))
	mkdir -p ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} ${BUILD_FLAGS_MAC} ./out

.PHONY: install-mac
install-mac: build-current-mac  ## Build & install to /Applications (on macOS, Intel or Apple Silicon)
	cp -R ./out/${APPNAME}-darwin-x64/${APPNAME}.app /Applications || cp -R ./out/${APPNAME}-darwin-arm64/${APPNAME}.app /Applications
	rm -rf ./out

.PHONY: install-mac-homedir
install-mac-homedir: build-current-mac  ## Build & install to ~/Applications (on macOS, Intel or Apple Silicon)
	cp -R ./out/${APPNAME}-darwin-x64/${APPNAME}.app ~/Applications || cp -R ./out/${APPNAME}-darwin-arm64/${APPNAME}.app ~/Applications
	rm -rf ./out

.PHONY: build-all
build-all: clean check-deps  ## Build app for supported platforms (macOS/x64, macOS/arm64, windows/x64)
	mkdir -p ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} ${BUILD_FLAGS_MAC} -p mac -a x64 ./out
	pushd ./out/${APPNAME}-darwin-x64 &&  zip -r ../${APPNAME}-${VERSION}-macos-x64.zip ./${APPNAME}.app && popd
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} ${BUILD_FLAGS_MAC} -p mac -a arm64 ./out
	pushd ./out/${APPNAME}-darwin-arm64 &&  zip -r ../${APPNAME}-${VERSION}-macos-arm.zip ./${APPNAME}.app && popd
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -i icon.ico -p windows -a x64 ./out
	pushd ./out && zip -r ./${APPNAME}-${VERSION}-windows-x64.zip ./${APPNAME}-win32-x64 && popd
