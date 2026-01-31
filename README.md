# MenuBarSpacer

A small macOS SwiftUI app that lets you adjust the spacing between menu bar status items. It reads and writes the `NSStatusItemSpacing` preference and shows a live preview before you apply changes.

<img width="612" height="482" alt="MenuBarSpacer" src="https://github.com/user-attachments/assets/b767c127-3092-47cf-8906-0129e938f7dc" />

## Features
- Read the current menu bar spacing (custom or system default)
- Adjust spacing with a slider and live preview
- Apply a new spacing value
- Reset back to macOS default
- Optional logout prompt so changes take effect immediately

## How it works
MenuBarSpacer uses the macOS `defaults` system to read/write the `NSStatusItemSpacing` key in the current host’s global domain. This setting only takes effect after you log out and back in.

## Requirements
- macOS with Xcode installed
- Swift 5.7+ (Xcode-managed)
![Uploading MenuBarSpacer.png…]()

## Build & Run
1. Open `MenuBarSpacer.xcodeproj` in Xcode.
2. Select the `MenuBarSpacer` target.
3. Build and run (⌘R).

## Usage
1. Launch the app.
2. Set the desired spacing with the slider.
3. Click **Apply**.
4. Log out and back in to see the change.

To revert to the system default spacing, click **Reset to macOS Default**.

## Notes & Limitations
- A spacing of `0` may cause menu bar items to overlap.
- Large spacing values can push items off-screen.
- Changes apply per-host (current machine) and require logout/login.

## Project Structure
- `MenuBarSpacer/ContentView.swift` — main UI and actions
- `MenuBarSpacer/SpacingManager.swift` — reads/writes `NSStatusItemSpacing`
- `MenuBarSpacer/MenuBarSimulatorView.swift` — menu bar preview

## Tests
Xcode unit and UI test targets are included:
- `MenuBarSpacerTests`
- `MenuBarSpacerUITests`

## Contributing
Issues and PRs are welcome. If you add new features, include a short description and any relevant tests.
