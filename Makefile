# Based on https://github.com/cdzombak/nativefier-app-template

SHELL:=/usr/bin/env bash

VERSION=1.1.1
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
--inject userscript.js \
--fast-quit \
--darwin-dark-mode-support \
-i icon.icns
endef

# Also define name below; you may want its name on the filesystem to differ:
APPFILENAME="Lofi Cafe"

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

.PHONY: build
build: clean check-deps update-deps  ## Build app for the current platform
	mkdir -p ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} ./out

.PHONY: install-mac
install-mac: build  ## Build & install to /Applications (on macOS, Intel or Apple Silicon)
	cp -R ./out/${APPFILENAME}-darwin-x64/${APPFILENAME}.app /Applications || cp -R ./out/${APPFILENAME}-darwin-arm64/${APPFILENAME}.app /Applications
	rm -rf ./out

.PHONY: build-all
build-all: clean check-deps  ## Build app for supported platforms
	mkdir -p ./out
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -p mac -a x64 ./out
	pushd ./out/${APPFILENAME}-darwin-x64 &&  zip -r ../${APPFILENAME}-${VERSION}-macos-x64.zip ./${APPFILENAME}.app && popd
	npm exec nativefier -- ${URL} ${BUILD_FLAGS} -p mac -a arm64 ./out
	pushd ./out/${APPFILENAME}-darwin-arm64 &&  zip -r ../${APPFILENAME}-${VERSION}-macos-arm.zip ./${APPFILENAME}.app && popd
