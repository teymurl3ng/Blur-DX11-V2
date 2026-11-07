# Blur DX11 V2 verification

This source baseline includes the v1.6 DX11 rebuild and the subsequent controller, display, renderer, settings, save and installer repairs. The game requires the data from a local retail Blur installation.

The Windows x64 Release development build reported zero build errors. USB and Bluetooth DualSense gameplay and vibration were tested with InputFusion. The graphics menu showed all eight rows, and a 90 FPS limit persisted across a fresh launch. The save worker recreated its directory and produced a save that loaded in a later session. The photo enumerator returned its maximum of 200 entries from 201 files. The installer fixture passed install, update, invalid backup rejection, uninstall and restoration.

The separate race colour corruption is still under investigation. The intermittent empty Options state, mixed-monitor hot-plug, and clean Windows prerequisite install need further verification.


## V2 installer and release preparation

The V2 installer retains the earlier setup identity and backup directory to support upgrades with original-file restoration. Its visible name, shortcuts and project URL identify Blur DX11 V2. Package preparation records the source commit, build configuration and payload hashes in build-info.json, and installer preparation verifies those files before compiling setup.

The release workflow builds candidates on main and pull requests. Version tags and an explicit manual request create a draft preview after the installer fixture passes. Publication follows gameplay verification. Clean Windows first-time prerequisite installation and mixed-monitor hot-plug remain pending.
