---
name: powershell-readline-icons
description: Install and configure PSReadLine and Terminal-Icons for the documented Windows PowerShell 7 terminal experience. Use when Codex needs to improve command editing, history prediction, completion display, or file icons in an interactive PowerShell profile.
---

# PowerShell ReadLine Icons

Use this skill to add interactive shell usability after the profile core exists.

## Install Or Verify

Check modules first:

```powershell
Get-Module -ListAvailable PSReadLine, Terminal-Icons
```

Install missing modules for the current user:

```powershell
Install-Module -Name PSReadLine -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
```

If PowerShell Gallery access fails, report the failure and continue without writing broken imports.

## Profile Integration

Add these inside the interactive shell guard:

```powershell
Import-Module PSReadLine -ErrorAction SilentlyContinue
if (Get-Module PSReadLine) {
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineOption -PredictionViewStyle InlineView
}

Import-Module Terminal-Icons -ErrorAction SilentlyContinue
```

Do not place these outside the interactive guard.

## Tuning

Prefer `InlineView` as the documented default.

If the user says predictions are visually noisy, switch to:

```powershell
Set-PSReadLineOption -PredictionViewStyle ListView
```

If the user wants prediction disabled:

```powershell
Set-PSReadLineOption -PredictionSource None
```

## Validation

Run:

```powershell
. $PROFILE
Get-Module PSReadLine, Terminal-Icons
Get-Module -ListAvailable PSReadLine, Terminal-Icons
```

Then visually confirm:

- History prediction appears while typing.
- `Get-ChildItem` output shows icons when the font supports them.
