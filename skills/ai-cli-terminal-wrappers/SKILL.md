---
name: ai-cli-terminal-wrappers
description: Configure safe PowerShell wrappers and documentation for OpenAI Codex CLI and GitHub Copilot CLI in the Windows terminal setup. Use when Codex needs to install, verify, or wrap codex and copilot commands without copying auth state, tokens, logs, or sessions.
---

# AI CLI Terminal Wrappers

Use this skill to integrate AI CLIs into the PowerShell profile.

## Safety Rules

Never copy or commit:

- `%USERPROFILE%\.codex\auth.json`
- `%USERPROFILE%\.codex\history.jsonl`
- `%USERPROFILE%\.codex\sessions`
- `%USERPROFILE%\.codex\logs_*.sqlite*`
- `%USERPROFILE%\.codex\state_*.sqlite*`
- `%USERPROFILE%\.codex\.sandbox-secrets`
- VS Code user settings that contain MCP tokens

Users should sign in again on the target machine.

## Install Or Verify

Install or update with npm when requested:

```powershell
npm install -g @openai/codex @github/copilot
```

Verify:

```powershell
Get-Command -All codex,copilot
npm root -g
npm prefix -g
codex --version
copilot --version
```

Do not assume the global npm shim path until `npm prefix -g` and `Get-Command -All codex,copilot` have been checked.

Common npm global shims on this setup are under:

```text
C:\Program Files\nodejs\codex.ps1
C:\Program Files\nodejs\copilot.ps1
```

If the shims live elsewhere, use the discovered paths in the wrapper or avoid adding wrappers and report the path mismatch.

## Codex Wrapper

Add to the profile only when the discovered npm shim exists. Prefer resolving the command dynamically instead of hard-coding a path:

```powershell
function codex {
  $codexScript = (Get-Command codex.ps1 -ErrorAction SilentlyContinue | Select-Object -First 1).Source
  if (-not $codexScript) {
    $codexScript = Join-Path $env:ProgramFiles "nodejs\codex.ps1"
  }
  if (-not (Test-Path $codexScript)) {
    throw "codex.ps1 npm shim not found. Run: npm install -g @openai/codex"
  }
  & $codexScript @args
}
```

Do not force `NO_COLOR=1` unless the user explicitly asks for colorless output.

## Copilot Wrapper

Prefer the narrowest Copilot permissions that still support the user's workflow. Do not use `--allow-all-*` unless the user explicitly asks for a broad agent mode.

Default wrapper:

```powershell
function copilot {
  $copilotScript = (Get-Command copilot.ps1 -ErrorAction SilentlyContinue | Select-Object -First 1).Source
  if (-not $copilotScript) {
    $copilotScript = Join-Path $env:ProgramFiles "nodejs\copilot.ps1"
  }
  if (-not (Test-Path $copilotScript)) {
    throw "copilot.ps1 npm shim not found. Run: npm install -g @github/copilot"
  }
  & $copilotScript `
    '--deny-tool=shell(Remove-Item:*)' `
    '--deny-tool=shell(Move-Item:*)' `
    '--deny-tool=shell(Set-Content:*)' `
    '--deny-tool=shell(Out-File:*)' `
    '--deny-tool=shell(reg:*)' `
    '--deny-tool=shell(del:*)' `
    '--deny-tool=shell(erase:*)' `
    '--deny-tool=shell(rd:*)' `
    '--deny-tool=shell(rmdir:*)' `
    '--deny-tool=shell(rm:*)' `
    @args
}
```

If broad mode is explicitly requested, keep destructive deny rules even when adding broad allow flags:

```powershell
--allow-all-tools
--allow-all-paths
--allow-all-urls
```

If the local Copilot CLI changes its flags, inspect `copilot --help` and adjust the wrapper instead of blindly preserving stale flags. If deny flags are unsupported, do not install a permissive wrapper without user approval.

## VS Code Notes

Only move redacted VS Code settings summaries. Do not copy raw user settings that may include tokens.

## Validation

Run:

```powershell
. $PROFILE
Get-Command -All codex,copilot
npm root -g
npm prefix -g
codex --version
copilot --version
```
