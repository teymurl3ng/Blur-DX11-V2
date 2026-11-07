# Controller, display and graphics-menu additions

This development branch starts from `uKER/BlurRebuilt` master at
`a3f14caf6abc20f832dd0114561381908fee8f3f`. The two commits after the tested
v1.6 base only edit README.md. No retail assets, saves or machine-specific
launch preferences are tracked by these changes.

## Changes

* `Pad360` explicitly calls the bundled, unmodified InputFusion 0.4.1 backend.
  The existing game mappings and rumble behavior are preserved. The DLL stays
  loaded for process lifetime because its SDL worker owns controller handles.
  Missing/incompatible libraries fall back to Windows XInput and log the reason.
* The game embeds a PerMonitorV2 DPI manifest. The original v1.6 executable
  lacked DPI awareness; the affected laptop created a 2400x1350 physical
  fullscreen window on a 1920x1080 screen. The tested manifest gives a matching
  1920x1080 window without Windows bitmap scaling.
* The DX11 device explicitly requests a high-performance hardware adapter.
  `renderer-startup.log` identifies the actual created device and software
  fallback. This avoids the affected laptop's problematic AMD/default-adapter
  path by selecting NVIDIA; it does not repair AMD shader/rendering faults.

`BLUR_INPUT_BACKEND=system` selects the original input path for comparison.
`BLUR_DX11_GPU=system` preserves OS/default adapter selection. Explicit WARP
requests still take precedence. There is no hardcoded SDR or frame cap in these
source changes, and no controller app is required for the InputFusion path.

## Build

Use the prerequisites and generation order in [the build reference](../agent-reference/build.md)
and [x64 notes](x64.md). Prepare the additional pinned dependency first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/inputfusion/setup.ps1
```

The script verifies both the release archive and extracted x64 DLL with SHA256.
For offline setup, pass `-ArchivePath <InputFusion.7z>`. Dependency files and
provenance are stored under ignored `_work/vendor` and `_work/vendor_dl`.
CMake defaults `BLUR_WITH_INPUTFUSION=ON` for x64, validates the DLL, and copies it
plus its notices beside Amax.exe. The release workflow prepares and packages the
same dependency. Configure `-DBLUR_WITH_INPUTFUSION=OFF` to build only the original
Windows XInput path without downloading or shipping InputFusion.

Use Release for the standard development check and MinSizeRel for the Master
player build. VS2022's legacy inline/header compatibility stopgaps are isolated
in `cmake/overrides.cmake`; T273 tracks their removal after lower-phase correction.

## Verification and limits

The original local prototype passed standard Release and Master builds. The user
verified correct colours/chrome, 1080p fullscreen, controller controls and rumble
with DS4Windows closed. The same unchanged InputFusion dependency had also passed
USB and Bluetooth tests; the final integrated-build reply did not specify its
connection transport. A manual launch was verified on NVIDIA RTX4050 hardware,
PerMonitorV2 awareness, and an exact 1920x1080 physical fullscreen window.

Fresh-project dependency setup, optional configuration and build results are
recorded in the phase ledger. These are compatibility and input additions,
not a measured performance improvement or a claim that all upstream rendering
issues are resolved. Blur DX11 V2 release builds record the source revision in build-info.json.

## Graphics menu

Anti-aliasing currently uses MSAA. The DX11 manager probes Off, 2x, 4x, 8x and
16x and exposes only sample counts supported by its colour and depth format
checks. The current laptop exposes Off / 2x / 4x / 8x. FXAA, SMAA and TAA are
not implemented; adding those requires renderer work, not extra menu labels.

Graphics options now include Maximum FPS: Unlimited, 30, 60, 90, 120 and 144.
Select the limit, choose Accept, and confirm within the existing ten-second
countdown. Back, No and timeout restore the previous selection. The display-mode
selector reads Windowed / Fullscreen, and the FPS and V-Sync rows explain how
the two limits interact. Resolution, anti-aliasing and quality retain their
existing behavior. Borderless, refresh-rate selection and render scaling are
not part of this first milestone.

The limit is saved in `%APPDATA%\Bizarre Creations\Blur\settings.xml`, in a
separate `<rebuilt_graphics_settings version="1" max_fps="60"/>` element.
Existing settings files default to Unlimited. Invalid values and unsupported
extension versions default to Unlimited. A manually supplied integer from 1
through 1000 is retained as an extra menu choice; 0 means Unlimited.
No profile/save-game binary layout changes.

`BLUR2PC_FRAMELIMIT` remains a startup override (0â€“1000); menu changes work live
after startup. A launcher setting that variable will override the saved choice
on the next launch, so ordinary launchers should leave it unset. This controls
rendering only; the existing fixed-step simulation remains unchanged. New labels
and explanatory text currently use English; existing retail labels retain their
localization.

## Player diagnostics

Normal launches suppress the developer log overlay, FPS counter and performance
panel. Diagnostics require the explicit `BLUR2PC_DIAGNOSTICS=1` environment
variable. Existing debug variables still control individual panels when that
switch is enabled. An old debug_values.xml cannot enable these overlays by
itself. The local player launcher clears this switch and automation variables.
Diagnostic file logging and game settings remain available.

The same switch also gates developer-menu input and the effective Game.DevMode
callback. Normal launches retain the game's pause-menu controls even when old
debug preferences are present. Fullscreen resolution changes preserve the active
output's current refresh where supported, preventing the first enumerated 24 Hz
TV mode from becoming the automatic choice. This does not add a refresh selector.
The renderer-startup.log file records the actual output mode and V-Sync interval
at startup and when those presentation parameters change.

## Portable dependencies

The recommended release artifact is now the offline Setup EXE. It places the
complete Rebuilt payload and InputFusion together, handles the bundled Microsoft
x64 C++ runtime, checks the selected Blur folder and refuses files in use.
It backs up replaced files and restores them on uninstall. The portable ZIP is
an optional manual path. Build the setup with tools/installer/build.ps1; this
prepares a verified portable Inno compiler and signed Microsoft redistributable.
Neither compiler nor developer tools are installed on the player's computer.

Players need the existing Windows 10/11 x64, DirectX 11 and current x64 Visual
C++ runtime prerequisites. Both the game and InputFusion dynamically use that
runtime, so backend fallback does not make the game's C++ runtime optional.
Copy BlurInputFusion.dll and InputFusion-Licenses beside the executable, along
with the complete fx11 folder. SDL and Detours are compiled into the backend;
no separate SDL installation, DS4Windows, ViGEm, Steam or NVIDIA App is required.
The controller must be connected by USB or paired/visible in Windows Bluetooth.
Missing, invalid or unloadable backend libraries fall back to system XInput;
direct DualSense support is lost in that mode, while existing XInput remains.

The build-only additions are the pinned backend archive, PowerShell and a
tar.exe supporting 7z input. Setup checks both archive/DLL hashes, supports an
offline -ArchivePath, and the existing BLUR_WITH_INPUTFUSION=OFF build avoids
that dependency. The GPU preference code needs Windows SDK dxgi1_6.h when
building; unsupported runtime interfaces fall back to OS adapter selection.
Shaders are built/packaged using the existing SDK tools. Players do not need
Python, CMake, Visual Studio, an SDK, fxc.exe or Microsoft Graphics Tools.

A follow-up audit compared official/current PE dependency lists (identical DLL
names), inspected the backend's imports and exercised the production backend
in five isolated loader cases: present, missing, missing transitive dependency,
bad image and explicit system selection. All passed. These are component tests
on the development PC, not a clean Windows VM or second-PC acceptance test.

## Codex context

This standalone checkout uses the Blur1PCDX11 phase documents. The inherited
agent_context.py helper only recognizes the original phase folder names; with a
custom project folder, read docs/blur1pcdx11/BOARD.md and LEDGER.md directly.
Keep following the upstream AGENTS.md phase and ownership rules.

Fresh-project validation completed: pinned download and checksums, ON/OFF CMake
configuration, clean standard x64 Release build, disabled-backend module compile,
canonical artifact hashes, embedded PerMonitorV2, and the workflow Package body
using local Release artifacts all pass. The package includes the backend, its
notices and this document. A remote GitHub Actions run and a fresh Master build
were not part of this project-setup validation.
