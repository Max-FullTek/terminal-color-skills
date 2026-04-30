---
name: terminal-color-skills
description: Apply the bundled Warm Sand color scheme to Windows Terminal on the current Windows machine. Use when the user wants to install this color scheme or attach it to one or more Windows Terminal profiles.
---

# Terminal Color Skills

Use this skill to apply the bundled `Warm Sand` color scheme to Windows Terminal using the scheme defined in this skill.

This skill is intentionally scoped to Windows Terminal on Windows color settings. The scheme is already included below, so do not search the machine for other local theme files or source palettes unless the user explicitly asks to create a different color scheme.

## Start Here

- Treat the bundled palette in this skill as the source of truth.
- Discover the real Windows Terminal `settings.json` path on the current machine before editing.
- Add or update one named scheme first, then attach it only to the profiles the user asked to change.
- Do not broaden scope to other terminals or non-color Windows Terminal settings unless the user explicitly asks.

## Workflow

1. Discover files on the current machine.
- For Windows Terminal, check these paths in order and use the first one that exists:
  - `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
  - `%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json`
- If neither path exists or the file cannot be edited, ask the user which Windows Terminal settings file should be used.

2. Read `settings.json`.
- Check whether the target profile already has `colorScheme`.
- Check whether a scheme named `Warm Sand` already exists.
- Limit edits to `schemes` and profile `colorScheme` unless the user explicitly asks for more.

3. Build or update the bundled scheme.
- Use the exact bundled scheme below as the default.
- Preserve the bundled background unless the user explicitly asks for a broader restyle.
- Set `cursorColor` and `selectionBackground` exactly; do not leave them implicit.

4. Apply with minimum scope.
- If the user wants only their main shell updated, attach the scheme only to that profile.
- Avoid mass-editing SSH or other profiles unless the user asked for global consistency.

5. Validate and iterate.
- Re-read `settings.json` after editing and confirm the target profiles reference the intended scheme.
- If the user says gray text is still too dim, raise `brightBlack` first.
- If normal body text is still too soft, raise `foreground` next.
- If highlights look muddy, raise `brightWhite` or `brightYellow` before touching the background.

## Bundled Palette

Use this exact scheme unless the user explicitly asks for a variant:

```json
{
  "name": "Warm Sand",
  "background": "#202222",
  "foreground": "#D2C4A4",
  "cursorColor": "#E6DBBF",
  "selectionBackground": "#3A3A3A",
  "black": "#232323",
  "red": "#C47E7E",
  "green": "#76968C",
  "yellow": "#B89A60",
  "blue": "#78948B",
  "purple": "#D291AA",
  "cyan": "#14AA84",
  "white": "#B4A68C",
  "brightBlack": "#A0AC9A",
  "brightRed": "#DC5F5F",
  "brightGreen": "#94B89A",
  "brightYellow": "#EBDCB4",
  "brightBlue": "#94AAA4",
  "brightPurple": "#E2A8BB",
  "brightCyan": "#66D9B5",
  "brightWhite": "#F0E8D0"
}
```

## Palette Roles

- Warm readable text -> `foreground` `#D2C4A4`
- Brighter readable text -> `brightYellow` `#EBDCB4`
- Muted gray text -> `brightBlack` `#A0AC9A`
- Dark neutral background -> `background` `#202222`
- Main green accent -> `green` `#76968C`
- Highlight green -> `brightGreen` `#94B89A`
- Teal accent -> `cyan` `#14AA84`
- Soft warning beige -> `yellow` `#B89A60`
- Selection block -> `selectionBackground` `#3A3A3A`

## Windows Terminal Notes

- This skill only manages Windows Terminal color settings through `schemes` and profile `colorScheme`.
- Do not modify font, opacity, acrylic, background images, tab settings, or command lines unless the user explicitly asks.
- Common Windows Terminal paths:
  - Packaged app: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
  - Unpackaged install: `%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json`

## Validation

After editing, re-read the selected Windows Terminal settings file and confirm:

- Exactly one `schemes` entry named `Warm Sand` exists.
- The requested profile or profiles reference `colorScheme: "Warm Sand"`.
- No unrelated profile command lines, SSH profiles, startup actions, font settings, opacity settings, or keybindings were changed by this skill.

## Mapping Heuristics

- This palette works best with a charcoal background and cream foreground rather than pure black and pure white.
- Keep `brightBlack` visibly readable. It is often the main source of "灰字太暗".
- Use `selectionBackground` as a soft neutral block, not a saturated accent.
- Keep red and warning colors slightly softened unless the user explicitly asks for a higher-contrast variant.

## GitHub Handoff Behavior

- If the user pastes the repo homepage URL, read the repo root `README.md` first, then install from `skills/terminal-color-skills`.
- If the user pastes a GitHub URL for this skill directly, prefer the skill directory path `skills/terminal-color-skills` or a direct `.../tree/<ref>/skills/terminal-color-skills` URL.
- Treat this `SKILL.md` as the source of truth for the workflow and bundled palette.
- Read `references/warm-sand.md` only if the user asks for palette rationale or wants to tune the colors beyond the default workflow.
- Do not look for other local theme source files as part of the default flow.
