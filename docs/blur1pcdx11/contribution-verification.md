# Blur DX11 V2 verification

This source baseline includes the v1.6 DX11 rebuild and the subsequent controller, display, renderer, settings, save and installer repairs. The game requires the data from a local retail Blur installation.

The Windows x64 Release development build reported zero build errors. USB and Bluetooth DualSense gameplay and vibration were tested with InputFusion. The graphics menu showed all eight rows, and a 90 FPS limit persisted across a fresh launch. The save worker recreated its directory and produced a save that loaded in a later session. The photo enumerator returned its maximum of 200 entries from 201 files. The installer fixture passed install, update, invalid backup rejection, uninstall and restoration.

The separate race colour corruption is still under investigation. The intermittent empty Options state, mixed-monitor hot-plug, and clean Windows prerequisite install need further verification.


## V2 installer and release preparation

The V2 installer retains the earlier setup identity and backup directory to support upgrades with original-file restoration. Its visible name, shortcuts and project URL identify Blur DX11 V2. Package preparation records the source commit, build configuration and payload hashes in build-info.json, and installer preparation verifies those files before compiling setup.

The release workflow builds candidates on main and pull requests. Version tags and an explicit manual request create a draft preview after the installer fixture passes. Publication follows gameplay verification. Clean Windows first-time prerequisite installation and mixed-monitor hot-plug remain pending.


## Published preview verification

The v2.0.0-preview.1 assets were built from 35f7fe8bf7d499364e6744f0069d2ec696fa7577 using the standard x64 Release pipeline. Both the full build and the final incremental check reported zero errors. The installed executable SHA-256 is 15878947EFBB8D3BF16667E1040A0B440D91DE7961BBFEF412ED6CC68AD70566.

The 5,000-file installer passed fresh install, update, migration from the previous Blur Rebuilt setup, uninstall, original-file restoration, busy-target rejection and damaged backup rejection in isolated fixture folders. The installed game loaded a race, opened the normal pause menu, populated Options and displayed all eight Graphics rows at 1280x720 windowed with the 90 FPS setting. The process exited successfully after 60 seconds. The renderer selected the RTX 4050 and the InputFusion backend loaded from the installed folder. This smoke run did not repeat physical USB or Bluetooth controller testing.

All archived payload hashes matched build-info.json. The public release assets were downloaded and checked against the local candidate hashes. The installer is unsigned. A clean Windows first-time runtime installation, mixed-monitor hot-plug and the intermittent rendering and Options issues remain pending.

The hosted Windows workflow at revision 699a2d9550468d16cd00534dc6c21d2a4a621804 passed its full Master build, installer compilation, legacy upgrade tests, checksums and artifact upload. [Successful hosted validation](https://github.com/teymurl3ng/Blur-DX11-V2/actions/runs/42422040179)
