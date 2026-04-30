---
name: terminal-audit-backup
description: Audit a Windows terminal environment and create safe backups before terminal beautification work. Use before editing Windows Terminal settings, PowerShell profile, VS Code user settings, or CLI wrapper configuration on a Windows machine.
---

# Terminal Audit Backup

Use this skill before changing local terminal configuration.

## Discover Files

Check Windows Terminal settings paths in order and use the first one that exists:

```powershell
$wtCandidates = @(
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
  "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
)
```

Use `$PROFILE` for the active PowerShell profile path.

Use this VS Code path only when the user asked for VS Code terminal integration:

```powershell
$vscodeSettings = "$env:APPDATA\Code\User\settings.json"
```

If no Windows Terminal settings file exists, ask the user which file to edit.

## Back Up

Create timestamped backups before editing any existing file:

```powershell
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (Test-Path $PROFILE) {
  Copy-Item $PROFILE "$PROFILE.bak.$stamp" -Force
}

foreach ($candidate in $wtCandidates) {
  if (Test-Path $candidate) {
    Copy-Item $candidate "$candidate.bak.$stamp" -Force
    break
  }
}

if (Test-Path $vscodeSettings) {
  Copy-Item $vscodeSettings "$vscodeSettings.bak.$stamp" -Force
}
```

Do not commit backup files.

## Rollback Notes

This skill creates backups, but later phases must still avoid risky blind overwrites. If a later edit breaks a profile or settings file, restore the matching backup manually with `Copy-Item`.

Example rollback commands:

```powershell
# Restore PowerShell profile from a known backup.
Copy-Item "$PROFILE.bak.<timestamp>" $PROFILE -Force

# Restore Windows Terminal settings from a known backup.
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item "$wtSettings.bak.<timestamp>" $wtSettings -Force

# Restore VS Code settings from a known backup.
$vscodeSettings = "$env:APPDATA\Code\User\settings.json"
Copy-Item "$vscodeSettings.bak.<timestamp>" $vscodeSettings -Force
```

When reporting backups, include exact backup file paths so the user can roll back quickly.

## Inventory

Collect versions and commands when available:

```powershell
pwsh --version
winget --version
npm --version
npm root -g
npm prefix -g
oh-my-posh version
codex --version
copilot --version
Get-Command pwsh,winget,npm,oh-my-posh,rg,fzf,zoxide,broot,codex,copilot -ErrorAction SilentlyContinue
Get-Module -ListAvailable PSReadLine, Terminal-Icons
```

It is acceptable for some commands to be missing during the audit. Missing tools become inputs for later phases.

## Safety Rules

- Never copy raw Codex `auth.json`, history, sessions, logs, sqlite state, or `.sandbox-secrets`.
- Never copy full VS Code user settings if they may contain tokens.
- Never copy full Windows Terminal settings from another machine if they may contain private SSH profiles.
- Prefer documented snippets and local merging over wholesale replacement.

## Output

Before handing off to the next phase, summarize:

- Files found
- Backups created
- Rollback paths for each backup
- Missing tools
- Tools already installed
- Any path that needs user confirmation

## Validation

Before continuing, confirm:

```powershell
Test-Path $PROFILE
Get-Command pwsh,winget,npm -ErrorAction SilentlyContinue
```

Also confirm that every existing file that will be edited in later phases has a timestamped backup path in the handoff summary. If a target file does not exist yet, report that it will be created rather than backed up.
