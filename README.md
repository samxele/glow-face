# Glow Face

Glow Face is a small SwiftUI companion for Apple Watch and the macOS menu bar.
It keeps the character still and uncluttered, with a brief blink at natural,
randomized intervals.

## What is included

- **Apple Watch app:** a responsive face with a digital clock, light and dark
  backgrounds, and reduced-luminance support.
- **macOS menu-bar app:** a blinking face that stays in the menu bar without
  adding an icon to the Dock. Select it to see the larger face or quit the app.

## Download

### Clone with Git

```sh
git clone https://github.com/samxele/glow-face.git
cd glow-face
```

Because the repository is private, GitHub will ask you to authenticate.

### Download a ZIP

1. Open the repository on GitHub.
2. Select **Code**, then **Download ZIP**.
3. Double-click the downloaded ZIP file to extract it.

## Use the Apple Watch app

### Requirements

- macOS with Xcode 16 or newer
- Apple Watch running watchOS 10 or newer, or a watchOS Simulator
- An Apple ID added to Xcode when installing on a physical watch

### Run in the watchOS Simulator

1. Open `GlowFaceWatch.xcodeproj` in Xcode.
2. Select the **Glow Face Watch App** scheme.
3. Choose an Apple Watch Simulator from the run-destination menu.
4. Select **Run** or press `Command-R`.

### Install on a physical Apple Watch

1. Pair the watch with the iPhone connected to your Mac.
2. Open `GlowFaceWatch.xcodeproj` in Xcode.
3. Select the **Glow Face Watch App** target, then open **Signing & Capabilities**.
4. Choose your development team. If needed, replace the example bundle
   identifier with a unique value.
5. Choose your Apple Watch as the run destination and press `Command-R`.

### Important watchOS limitation

Apple does not allow third-party apps to replace the system watch face. Glow
Face is a watch app that looks like a face while it remains open. Its visibility
is controlled by the watch's **Return to Clock** settings. In reduced-luminance
Always On mode, Glow Face dims its colors, stops blinking, and updates the clock
less frequently.

## Use the macOS menu-bar app

### Requirements

- macOS 13 or newer
- Xcode Command Line Tools

Install the command-line tools if they are not already available:

```sh
xcode-select --install
```

From the downloaded project directory, run:

```sh
swift run -c release GlowFaceMenuBar
```

The first launch may take a moment while Swift builds the app. The blinking face
then appears on the right side of the menu bar. Keep the Terminal process
running while using it. Select the face and choose **Quit Glow Face** to stop it.
Run the same command whenever you want to launch it again.

## Project structure

```text
GlowFaceWatch/       Apple Watch SwiftUI source and artwork
GlowFaceMenuBar/     macOS menu-bar source and resources
GlowFaceWatch.xcodeproj/
Package.swift        Swift Package used by the macOS app
```

The project requires no network access, permissions, or external packages while
running.
