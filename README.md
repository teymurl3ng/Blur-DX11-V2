# Blur DX11 V2

Independent Windows setup and controller preparation tools for a local Blur DX11 installation. The project distributes PowerShell and Inno Setup source. Provide your own installed copy of Blur and compatible x64 DX11 build files.

## Build an installer locally

Prepare a staging directory containing these files from your own build.

- `BlurRebuilt.exe` and `AmaxClientHost.exe`
- `fx11/effects.index` and the build's matching effects files
- A `README.md` for your package. You can copy this one.

Run these commands from this repository in PowerShell. Replace the staging directory with your own.

```powershell
$stage = 'C:\path\to\my-stage'
.\tools\inputfusion\setup.ps1
Copy-Item .\_work\vendor\inputfusion-0.4.1\BlurInputFusion.dll $stage
Copy-Item .\notices\InputFusion (Join-Path $stage 'InputFusion-Licenses') -Recurse
.\tools\installer\build.ps1 -Stage $stage -Version '0.1.0'
```

The controller script verifies InputFusion 0.4.1 against pinned SHA-256 hashes. The installer builder verifies its dependencies and writes an installer and build metadata to `_work/installer`. Run the installer and select the directory containing your retail `Blur.exe`. Setup tracks its own files and backs up files it replaces so uninstall can restore them.

## Credits

Bizarre Creations created Blur. [uKER and the Blur Rebuilt contributors](https://github.com/uKER/BlurRebuilt) developed the DX11 port. [xan105](https://github.com/xan105/InputFusion) develops InputFusion. Its component notices are in [notices/InputFusion](notices/InputFusion).
