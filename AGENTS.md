# Agent Handoff

This repository documents the Windows Terminal, PowerShell, Oh My Posh, navigation tools, Codex CLI, and GitHub Copilot CLI setup for replication on another Windows machine.

It contains a full set of installable Codex skills under `skills/`. Use `skills/terminal-beautify-main` for the full rebuild flow. Use `skills/terminal-color-skills` only when the user wants the bundled Windows Terminal color scheme applied.

Start here:

1. Read `docs/windows-terminal/README.md`.
2. For a new machine restore, follow `docs/windows-terminal/13-遠端重建與-Agent-交接.md`.
3. If something breaks, check `docs/windows-terminal/14-疑難排解與踩坑紀錄.md` before improvising.
4. Do not commit raw local config files that may contain tokens, SSH hosts, history, logs, or auth state.

Important:

- Windows Terminal full `settings.json` may contain private SSH profiles. Merge only the documented appearance snippets unless the user explicitly approves copying the full file.
- VS Code `settings.json` may contain MCP tokens. Use the redacted settings summary in the restore guide.
- Codex auth, history, sessions, logs, and sqlite state are local-only and must not be copied into the repo.
- Do not use `zoxide init powershell | Invoke-Expression`; capture the init output, join it into one string, then invoke it if non-empty.
- broot uses its own `codex-muted-green.hjson` skin. Windows Terminal `Warm Sand` alone does not style broot.
