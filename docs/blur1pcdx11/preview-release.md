# Blur DX11 V2 preview

This preview includes the full x64 DX11 rebuild, bundled InputFusion 0.4.1 controller support, DPI and GPU selection changes, saved FPS controls, graphics menu layout repairs, save and photo fixes, and automatic setup.

Download the file ending in `-Setup.exe`, run it, and select your installed Blur folder containing `Blur.exe`. Start **Blur DX11 V2** from the Start menu. The installer includes the Microsoft x64 C++ runtime and controller backend. Connect DualSense by USB or pair it with Windows Bluetooth.

The installation requires the data from an existing PC copy of Blur. Online play additionally requires the Amax Emu client and configuration described in the README.

## Known issues

Race scenes can develop coloured rectangular corruption after race loading. Restarting the game has cleared affected sessions in reported tests. The first faulty rendering operation remains under investigation. Intermittent empty Options and mixed-monitor transitions also need further testing.

## Verification

See contribution-verification.md for the tested build and installer results. Each package includes build-info.json with its source revision, build configuration, and payload hashes. The release includes a SHA256SUMS.txt file for its downloadable assets.

## Upgrade and uninstall

V2 upgrades an earlier Blur Rebuilt setup in the same game folder. It keeps the existing setup identity and backup history so uninstall can restore files from before the original setup. Use a separate game folder for a second independent installation. Uninstall through Windows Installed apps.
