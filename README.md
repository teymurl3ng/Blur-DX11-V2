# Blur DX11 V2

A Windows x64 DX11 continuation of **Blur**, the 2010 racing game by Bizarre Creations, based on [uKER and the Blur Rebuilt contributors’ work](https://github.com/uKER/BlurRebuilt).

## Download and install

**[Download the preview installer](https://github.com/teymurl3ng/Blur-DX11-V2/releases/download/v2.0.0-preview.1/BlurDX11V2-v2.0.0-preview.1-Setup.exe)**

[Release notes, portable ZIP and SHA-256 checksums](https://github.com/teymurl3ng/Blur-DX11-V2/releases/tag/v2.0.0-preview.1)

This is a preview. Race scenes can develop coloured rectangular corruption after race loading. Restarting the game has cleared affected sessions in reported tests. This issue is still being investigated.

1. Install your existing PC copy of Blur. Windows 10 or 11, 64-bit, and a DirectX 11 graphics card are required.
2. Download the file ending in `-Setup.exe` above and run it. Windows requests administrator access during installation.
3. Select your game folder containing `Blur.exe` and complete setup.
4. Open **Blur DX11 V2** from the Start menu. An optional desktop shortcut is available during setup.

Setup installs the rebuilt game, matching shader effects, InputFusion controller support and the required Microsoft x64 C++ runtime together. Installation works offline after downloading the setup file. It uses the data from your existing Blur installation.

Connect a DualSense with a USB data cable or pair it in Windows Bluetooth. InputFusion provides controls and vibration without a controller translation app. If the backend fails to load, the game falls back to Windows XInput. Direct DualSense support then requires correcting the backend load failure.

### Upgrading and uninstalling

Close the game before updating. V2 upgrades a previous Blur Rebuilt setup in the same folder and retains its backup history. Use a separate game folder for another independent installation. Windows Installed apps lists **Blur DX11 V2** after setup, and uninstall restores the files saved by the original installation backup.

The retail executable is retained. Saves are shared with retail Blur under `%APPDATA%\Bizarre Creations\Blur`. Back up that folder before testing a preview.

### Portable installation

The release also provides `BlurDX11V2-<version>.zip`. Extract its contents into your installed Blur folder and run `BlurRebuilt.exe`. A current Microsoft Visual C++ x64 runtime is required for this method. [Microsoft runtime download](https://aka.ms/vc14/vc_redist.x64.exe)

GitHub’s green **Code → Download ZIP** button downloads the source code. The runnable installer and portable package are in **Releases**.

## Included improvements

- The inherited native 64-bit DX11 renderer, HDR support, frame timing changes and ultrawide work.
- Bundled InputFusion 0.4.1 with DualSense controls and vibration tested over USB and Bluetooth.
- Per-monitor DPI awareness, explicit high-performance GPU selection and display mode handling.
- A saved Maximum FPS control and a graphics panel that keeps all eight rows visible.
- Texture-lock lifetime, particle allocation and two shader-interface repairs.
- Save creation and photo enumeration repairs, plus installer backup and restoration checks.
- Developer panels and performance displays require the explicit diagnostics switch during normal player launches.

## Known issues and testing

Coloured race corruption remains open. Intermittent blank Options, mixed-monitor hot-plug, and prerequisite installation on a clean Windows machine need further testing. [Verification details](docs/blur1pcdx11/contribution-verification.md)

Local acceptance tests used an NVIDIA RTX 4050 Laptop GPU, the laptop panel and a TCL 4K TV. Controller tests used DualSense over USB and Bluetooth. Hardware-specific results and outstanding checks are recorded with each preview.

## Online multiplayer

Online play uses Amax Emu. The package includes its compatibility host, but the Amax Emu client and account configuration are separate steps. Place the client files in `amax_client_files` and follow the service’s instructions. [Amax Emu setup](https://amax-emu.com/how_to_play)

## Build from source

The installer is the normal download for players. Developers can use the generation order and prerequisites documented in the build references. Prepare the pinned controller dependency with `powershell -File tools/inputfusion/setup.ps1`. Run `tools/build.sh` for the standard x64 Release pipeline, or `python tools/build/build.py` from a configured Windows developer environment.

[Build reference](docs/agent-reference/build.md) · [x64 notes](docs/blur1pcdx11/x64.md) · [Controller and graphics implementation](docs/blur1pcdx11/additions.md)

The release workflow creates a draft preview with the setup, portable ZIP, build metadata and checksums after package tests pass. A maintainer verifies gameplay before publishing the draft. Normal pushes build the package for verification without publishing a release.

## Optional settings

| Variable | Effect |
|---|---|
| `BLUR_DX11_HDR=off` | Use SDR output |
| `BLUR_DX11_HDR_PEAK_NITS=1000` | Override display peak brightness |
| `BLUR_DX11_HDR_PAPER_WHITE_NITS=200` | Override paper-white brightness |
| `BLUR2PC_FRAMELIMIT=120` | Override the render FPS cap |
| `BLUR2PC_DIAGNOSTICS=1` | Enable developer diagnostics |

## Credits and version history

Bizarre Creations created Blur. uKER and the Blur Rebuilt contributors developed the upstream rebuild. xan105 develops InputFusion, which includes SDL and Detours. Dependency notices are bundled with the controller backend. [InputFusion](https://github.com/xan105/InputFusion)

### V2 preview

The preview adds the controller integration, display and settings repairs, save fixes, and automatic installer described above. [Preview notes](docs/blur1pcdx11/preview-release.md)

### Upstream Blur Rebuilt

| Version | Changes recorded upstream |
|---|---|
| 1.6 | Audio timing correction and Amax client packaging |
| 1.5 | Additional ultrawide fixes and Amax Emu integration |
| 1.4 | Ultrawide menus |
| 1.3 | Dynamic controller glyphs |
| 1.2 | Reduced audio latency |
| 1.1 | Ultrawide race HUD |
| 1.0 | Initial rebuild |
