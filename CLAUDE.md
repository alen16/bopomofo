# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bopomofo Drop Game — an iOS SwiftUI game where Bopomofo (注音符號) characters fall from the top of the screen and the player taps matching keys on a virtual keyboard to eliminate them before they pile up past the danger line.

## Build & Run

This is an Xcode project. Open `bopomofo.xcodeproj` in Xcode and run on a simulator or device. There is no command-line build script; use Xcode's standard build (`Cmd+B`) and test (`Cmd+U`) workflows.

To run tests from the command line:
```bash
xcodebuild test -project bopomofo.xcodeproj -scheme bopomofo -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Architecture

The app uses MVVM with a single shared `GameViewModel` injected at the root and passed down via `@ObservedObject`.

**Data flow:**
- `BopomofoDropGameApp` creates one `GameViewModel` and passes it to `ContentView`
- `ContentView` switches between `MenuView` and `GameView` based on `viewModel.gameStatus`
- `GameView` renders the falling cards and embeds `VirtualKeyboardView`; overlays (`PauseOverlayView`, `GameOverOverlayView`) are shown conditionally on top

**Game loop (in `GameViewModel`):**
- A 60 fps `Timer` (`gameTimer`) calls `updateCards()` each frame — cards fall by `speed` per tick, land on the bottom or stack on top of resting cards, and trigger `endGame()` if any resting card reaches `dangerLineY`
- A separate `spawnTimer` fires on a variable interval to create new `BopomofoCard` values
- Difficulty scales with score: speed increases every 20 points (capped at 1.5), spawn interval decreases every 20 points (floor at 1.5 s)
- `removeCard(withCharacter:)` removes the lowest matching card and resets all remaining cards' `isResting = false` so they recalculate stacking positions

**Services (singletons):**
- `AudioService.shared` — plays system sounds (`AudioServicesPlaySystemSound`) and haptics
- `StorageService.shared` — persists high score and `GameSettings` to `UserDefaults`

**Constants** (`BopomofoConstants`): card size (70 pt), card margin (5 pt), danger line Y (100 pt), the 37-character set, keyboard layout rows, and pastel card colors.

**`gameAreaSize`** is set by `GameView.onAppear` from `GeometryReader` and passed to the view model so physics calculations use the actual runtime dimensions. The game area height is `geometry.size.height - 220` (the keyboard takes 220 pt).
