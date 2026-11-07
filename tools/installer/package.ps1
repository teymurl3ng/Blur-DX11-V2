[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$')][string]$Version,
    [ValidateSet('Release','MinSizeRel')][string]$Configuration = 'MinSizeRel',
    [string]$OutputDirectory
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
if (!$OutputDirectory) { $OutputDirectory = Join-Path $root '_work\release' }
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
$OutputDirectory = (Resolve-Path -LiteralPath $OutputDirectory).Path
$commit = (& git -C $root rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0) { throw 'Cannot identify the source commit' }
# Generators write LF files into a Windows checkout. Compare content rather than
# relying on the index's cached modification flags after generation.
$changes = @(& git -C $root diff --ignore-cr-at-eol --name-only HEAD --)
if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect source state' }
$dirty = $changes.Count -gt 0
$build = Join-Path $root '_work\build\vs'
$effects = Join-Path $root '_work\build\gen\fx11\effects'
$stage = Join-Path $OutputDirectory ('stage-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force $stage | Out-Null
$copies = @{
    'BlurRebuilt.exe' = Join-Path $build "$Configuration\Amax.exe"
    'AmaxClientHost.exe' = Join-Path $build "amax_client_host\$Configuration\AmaxClientHost.exe"
    'BlurInputFusion.dll' = Join-Path $build "$Configuration\BlurInputFusion.dll"
    'README.md' = Join-Path $root 'README.md'
}
foreach ($name in $copies.Keys) {
    Copy-Item -LiteralPath $copies[$name] -Destination (Join-Path $stage $name)
}
Copy-Item -LiteralPath (Join-Path $build "$Configuration\InputFusion-Licenses") -Destination (Join-Path $stage 'InputFusion-Licenses') -Recurse
$documents = Join-Path $stage 'docs\blur1pcdx11'
New-Item -ItemType Directory -Force $documents | Out-Null
foreach ($name in @('additions.md','contribution-verification.md','preview-release.md')) {
    Copy-Item -LiteralPath (Join-Path $root "docs\blur1pcdx11\$name") -Destination $documents
}
foreach ($file in Get-ChildItem -LiteralPath $effects -Recurse -File) {
    if ($file.Name -notin @('effects.index','effects.samplers') -and $file.Extension -ne '.fxo') { continue }
    $target = Join-Path (Join-Path $stage 'fx11') $file.FullName.Substring($effects.Length+1)
    New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
    Copy-Item -LiteralPath $file.FullName -Destination $target
}
if (!(Test-Path -LiteralPath (Join-Path $stage 'fx11\effects.index'))) { throw 'Missing effects index' }
$hashes = @(Get-ChildItem -LiteralPath $stage -Recurse -File | Sort-Object FullName | ForEach-Object {
    [ordered]@{Path=$_.FullName.Substring($stage.Length+1).Replace('\','/'); SHA256=(Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash}
})
$info = [ordered]@{
    Version=$Version
    SourceCommit=$commit
    Configuration=$Configuration
    SourceDirty=$dirty
    SourceChangedFiles=$changes
    ExecutableSHA256=(Get-FileHash -LiteralPath (Join-Path $stage 'BlurRebuilt.exe')).Hash
    Files=$hashes
}
$info | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $stage 'build-info.json') -Encoding utf8
$zip = Join-Path $OutputDirectory "BlurDX11V2-$Version.zip"
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -Force
[pscustomobject]@{Stage=$stage; Zip=$zip; SourceCommit=$commit; Configuration=$Configuration}
