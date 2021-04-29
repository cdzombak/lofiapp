# Lofi Cafe (& Friends) Electron App

![screenshot of the Lofi Cafe app playing lofi.cafe](./screenshot.png)

## macOS

### Installing from a downloaded package

1. Download the latest version for your machine from [the releases page](https://github.com/cdzombak/lofiapp/releases/latest). Unless you have a new Mac with an Apple Silicon processor, you need the `macos-x64` version.
2. Open the downloaded `.zip` file. This will extract the file `Lofi Cafe.app`.
3. Drag `Lofi Cafe.app` to your `Applications` folder.
4. To open the app the first time, you need to right-click `Lofi Cafe.app` in Finder and select Open in the context menu:

![right-click the app in Finder and select Open to launch it](install.png)

Failing to follow that last step will cause macOS to present a warning like this:

![warning that the app isn't signed](warning.png)

### Installing with developer tools (`make`, `npm`)

1. Install `npm` on your system.
2. Clone this repository.
3. Run `make install-mac` in this directory to build & install the app in `/Applications`.

## Protip

On lofi.cafe, hit the `L` key to enable "low power mode". The site seems to remember this preference for you.

