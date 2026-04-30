---
name: terminal-beautify-main
description: Orchestrate the full Windows terminal beautification and rebuild workflow from this repository. Use when Codex needs to audit a Windows machine, back up local terminal settings, apply Windows Terminal appearance and Warm Sand colors, rebuild PowerShell profile behavior, install prompt/navigation tools, and configure AI CLI wrappers in the documented order.
---

# Terminal Beautify Main

Use this skill as the top-level coordinator for recreating or refreshing the documented Windows terminal environment.

This skill should not contain every implementation detail. It should route the agent through the smaller skills in a safe order, with validation after each stage.

## Execution Order

Run these phases in order:

1. `terminal-audit-backup`
2. `windows-terminal-appearance`
3. `terminal-color-skills`
4. `powershell-profile-core`
5. `powershell-readline-icons`
6. `oh-my-posh-setup`
7. `terminal-navigation-tools`
8. `ai-cli-terminal-wrappers`

Stop after any phase that cannot be completed safely. Report the exact blocker, the files already changed, and the next manual decision needed.

## Phase Rules

- Always audit and back up before editing local machine settings.
- Prefer merging documented snippets into existing config files instead of replacing whole user files.
- Treat Windows Terminal SSH profiles, VS Code full user settings, Codex auth, logs, sessions, and tokens as private local state.
- Confirm `FiraCode Nerd Font Mono` is installed before relying on icon rendering.
- Confirm `npm root -g`, `npm prefix -g`, and actual CLI shim paths before adding AI CLI wrappers.
- Keep edits scoped to the phase being executed.
- Re-read each edited config file after writing it.
- Validate the visible shell behavior only after opening or reloading a fresh PowerShell session when practical.
- Do not pipe multi-line init script output directly to `Invoke-Expression`. Capture Oh My Posh and zoxide init output, join it into one string, check for non-empty text, then invoke it.
- Treat Windows Terminal `Warm Sand`, Oh My Posh themes, and broot skins as three separate layers. The full setup needs all three.

## Phase 1: Audit And Backup

Use `terminal-audit-backup`.

Confirm:

- Windows Terminal settings path
- PowerShell profile path
- VS Code settings path when VS Code integration is requested
- Existing versions of PowerShell, Oh My Posh, zoxide, fzf, ripgrep, broot, Codex CLI, and Copilot CLI
- Whether `winget`, `npm`, and the target Nerd Font are available
- Exact rollback paths for any backups created

Do not continue to config edits until backups have been created or the user explicitly accepts continuing without a missing backup.

## Phase 2: Windows Terminal Appearance

Use `windows-terminal-appearance`.

Apply only appearance and keybinding settings:

- `profiles.defaults.font`
- `profiles.defaults.opacity`
- `profiles.defaults.useAcrylic`
- `profiles.defaults.padding`
- `profiles.defaults.scrollbarState`
- `Shift+Enter` sendInput behavior for broot
- `Alt+Enter` unbound behavior

Do not copy private profiles from another machine.

## Phase 3: Color Scheme

Use `terminal-color-skills`.

Add or update the bundled `Warm Sand` scheme and attach it only to the requested Windows Terminal profile or profiles.

Use `Warm Sand` as the canonical scheme name unless the user explicitly asks to preserve a legacy name.

## Phase 4: PowerShell Profile Core

Use `powershell-profile-core`.

Create or merge the core profile structure:

- UTF-8 console defaults
- `WinGet Links` and `WindowsApps` session PATH fallback
- interactive shell guard
- completions loader
- extension points for the later phases

Avoid placing heavy interactive behavior outside the interactive guard.

## Phase 5: ReadLine And Icons

Use `powershell-readline-icons`.

Install or configure:

- PSReadLine
- Terminal-Icons
- history prediction settings

Keep this phase independent from Oh My Posh so shell input behavior can be debugged separately from prompt rendering.

## Phase 6: Oh My Posh

Use `oh-my-posh-setup`.

Install or verify Oh My Posh, initialize prompt rendering, and configure the documented `omp-theme` helper behavior.

Prefer user-level `OMP_THEME_NAME` for persistent theme selection and session-level `OMP_THEME_SESSION_NAME` for temporary preview.

## Phase 7: Navigation And Search Tools

Use `terminal-navigation-tools`.

Install or wire:

- zoxide
- fzf
- ripgrep
- broot

Configure `FZF_DEFAULT_COMMAND` only when both `rg` and `fzf` are available.

Also apply the bundled broot skin:

- Copy `../terminal-navigation-tools/references/codex-muted-green.hjson` to `%APPDATA%\dystroy\broot\config\skins\codex-muted-green.hjson`.
- Update broot `conf.hjson` so the dark/unknown import uses `file: skins/codex-muted-green.hjson`.
- If `broot --install` cannot create its launcher because of Windows symlink privileges, use broot's official `--print-shell-function powershell` output as the fallback and report the launcher state.

## Phase 8: AI CLI Wrappers

Use `ai-cli-terminal-wrappers`.

Configure wrappers for Codex CLI and GitHub Copilot CLI without copying auth state.

Use conservative Copilot wrapper permissions by default. Do not enable broad `--allow-all-*` behavior unless the user explicitly asks for it.

## Final Validation

After all requested phases complete, validate with commands like:

```powershell
pwsh --version
oh-my-posh version
Get-Module -ListAvailable PSReadLine, Terminal-Icons
Get-Command rg,fzf,zoxide,broot,codex,copilot
codex --version
copilot --version
```

Also confirm visually:

- Windows Terminal uses the expected font and acrylic appearance.
- The target profile references `Warm Sand`.
- broot `conf.hjson` references `codex-muted-green.hjson`.
- PowerShell opens without profile errors.
- Prompt, icons, history prediction, `z`, `b`, `rg`, and `fzf` work in an interactive shell.
