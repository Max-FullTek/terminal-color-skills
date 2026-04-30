---
name: oh-my-posh-setup
description: Install, initialize, and manage Oh My Posh for the documented Windows PowerShell terminal setup. Use when Codex needs to configure prompt rendering, user-level theme selection with OMP_THEME_NAME, session preview with OMP_THEME_SESSION_NAME, or the omp-theme helper workflow.
---

# Oh My Posh Setup

Use this skill after the PowerShell profile core exists.

## Install Or Verify

Prefer winget:

```powershell
winget install --id JanDeDobbeleer.OhMyPosh --exact --accept-source-agreements --accept-package-agreements
```

Verify:

```powershell
Get-Command oh-my-posh
oh-my-posh version
```

If winget is unavailable, report the blocker before using an internet install script.

## Theme Selection

Use user-level `OMP_THEME_NAME` for persistent selection:

```powershell
[Environment]::SetEnvironmentVariable("OMP_THEME_NAME", "robbyrussell", "User")
```

Use session-only `OMP_THEME_SESSION_NAME` for previews.

When both are absent, use a readable default such as `clean-detailed` if it exists; otherwise fall back to Oh My Posh default initialization.

## Profile Integration

Add Oh My Posh initialization inside the interactive guard and after PATH fallbacks.

Resolve the theme from:

1. `$env:OMP_THEME_SESSION_NAME`
2. User-level `OMP_THEME_NAME`
3. fallback default

Only pass `--config` when the target theme file exists. Otherwise run:

```powershell
$ompInit = (oh-my-posh init pwsh) -join "`n"
if (-not [string]::IsNullOrWhiteSpace($ompInit)) {
  Invoke-Expression $ompInit
}
```

Do not define a competing `prompt` function.

If zoxide is also enabled, run Oh My Posh first and zoxide after it. Oh My Posh rebuilds `prompt`, and zoxide attaches its directory tracking hook to `prompt`.

## omp-theme Helper

If the profile contains an `omp-theme` helper, it should support:

- `omp-theme current`
- `omp-theme list`
- `omp-theme preview <name>`
- `omp-theme set <name>`
- `omp-theme <name>`
- `omp-theme next`
- `omp-theme prev`
- `omp-theme tour`

The helper may discover themes from the installed Oh My Posh themes directory instead of hard-coding a short list.

If the profile defines `Invoke-ZoxideInit`, every helper path that reloads Oh My Posh should call `Invoke-ZoxideInit -Force` immediately after `Invoke-OmpInit`. This keeps zoxide directory tracking alive after `omp-theme preview`, `omp-theme set`, `omp-theme next`, `omp-theme prev`, and `omp-theme tour`.

## Validation

Run:

```powershell
. $PROFILE
oh-my-posh version
omp-theme current
```

Open a new PowerShell tab and confirm the prompt renders without errors.
