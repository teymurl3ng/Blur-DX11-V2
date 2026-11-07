# Blur DX11 V2 verification

This source baseline includes the v1.6 DX11 rebuild and the subsequent controller, display, renderer, settings, save and installer repairs. The game requires the data from a local retail Blur installation.

The Windows x64 Release development build reported zero build errors. USB and Bluetooth DualSense gameplay and vibration were tested with InputFusion. The graphics menu showed all eight rows, and a 90 FPS limit persisted across a fresh launch. The save worker recreated its directory and produced a save that loaded in a later session. The photo enumerator returned its maximum of 200 entries from 201 files. The installer fixture passed install, update, invalid backup rejection, uninstall and restoration.

The separate race colour corruption is still under investigation. The intermittent empty Options state, mixed-monitor hot-plug, and clean Windows prerequisite install need further verification.
