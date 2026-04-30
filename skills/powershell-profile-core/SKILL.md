---
name: powershell-profile-core
description: Build or merge the safe core PowerShell profile structure for this Windows terminal setup. Use when Codex needs to configure UTF-8 behavior, PATH fallbacks, interactive shell guards, completions loading, and extension points before adding prompt or tool integrations.
---

# PowerShell Profile Core

Use this skill to create the stable base of `Microsoft.PowerShell_profile.ps1`.

This skill should prepare the profile for later skills without taking ownership of every feature.

## Core Responsibilities

Configure:

- UTF-8 console input and output when available.
- Session PATH fallback for `%LOCALAPPDATA%\Microsoft\WinGet\Links`.
- Session PATH fallback for `%LOCALAPPDATA%\Microsoft\WindowsApps`.
- A reliable interactive shell guard.
- A completions loader for files under the profile directory's `Completions` folder.
- Clear regions or comments where later skills can add PSReadLine, Terminal-Icons, Oh My Posh, navigation tools, and AI CLI wrappers.

## Interactive Guard

Keep interactive-only behavior behind a guard so scripts, redirected output, and non-interactive commands do not fail.

Use a simple guard such as:

```powershell
$script:IsInteractiveShell = [Environment]::UserInteractive -and -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected
```

Then place prompt rendering, PSReadLine, Terminal-Icons, zoxide, fzf, broot, and completions inside:

```powershell
if ($script:IsInteractiveShell) {
  # interactive setup
}
```

## PATH Fallbacks

Prepend WinGet links so winget-installed tools win over bundled or editor-provided versions:

```powershell
$wingetLinks = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Links"
$windowsApps = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps"

foreach ($path in @($wingetLinks, $windowsApps)) {
  if ((Test-Path $path) -and (($env:PATH -split ';') -notcontains $path)) {
    $env:PATH = "$path;$env:PATH"
  }
}
```

## Completions Loader

Load completions only when the directory exists:

```powershell
$completionDir = Join-Path (Split-Path -Parent $PROFILE) "Completions"
if (Test-Path $completionDir) {
  Get-ChildItem $completionDir -Filter *.ps1 -File | ForEach-Object {
    . $_.FullName
  }
}
```

## Safety Rules

- Do not remove user aliases or functions unless they directly conflict with this setup and the user approved removal.
- Do not define a custom `prompt` function when Oh My Posh will manage the prompt.
- Do not make network calls from the profile.
- Keep missing tools non-fatal by checking `Get-Command` before initializing them.

## Validation

After editing:

```powershell
. $PROFILE
$?
```

Open a new PowerShell tab when possible and confirm there are no profile errors.
