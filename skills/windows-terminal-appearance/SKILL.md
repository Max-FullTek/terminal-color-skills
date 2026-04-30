---
name: windows-terminal-appearance
description: Apply the documented Windows Terminal appearance settings safely. Use when Codex needs to configure font, cell height, opacity, acrylic, padding, scrollbar behavior, or keybindings for the Windows Terminal setup in this repository.
---

# Windows Terminal Appearance

Use this skill to merge appearance settings into Windows Terminal `settings.json`.

This skill does not manage color schemes. Use `terminal-color-skills` for `schemes` and profile `colorScheme`.

## Scope

Manage only:

- `profiles.defaults.backgroundImage`
- `profiles.defaults.backgroundImageOpacity`
- `profiles.defaults.font`
- `profiles.defaults.opacity`
- `profiles.defaults.padding`
- `profiles.defaults.scrollbarState`
- `profiles.defaults.useAcrylic`
- `actions`
- `keybindings`

Do not change command lines, SSH profiles, profile names, startup actions, or color schemes unless the user explicitly asks.

## Target Defaults

Before writing the font setting, check whether the target Nerd Font is installed:

```powershell
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
(New-Object System.Drawing.Text.InstalledFontCollection).Families.Name |
  Where-Object { $_ -eq "FiraCode Nerd Font Mono" }
```

If the font is missing, report it before editing. Windows Terminal may silently fall back to another font, and icons may render as square boxes until the Nerd Font is installed.

Merge these values into `profiles.defaults`:

```json
{
  "backgroundImage": null,
  "backgroundImageOpacity": 0.2,
  "font": {
    "cellHeight": "1.3",
    "face": "FiraCode Nerd Font Mono",
    "size": 14,
    "weight": "medium"
  },
  "opacity": 40,
  "padding": "15",
  "scrollbarState": "hidden",
  "useAcrylic": true
}
```

Preserve unrelated existing keys.

## Keybindings

Ensure `Shift+Enter` sends `ESC + Enter` for the broot flow:

```json
{
  "command": {
    "action": "sendInput",
    "input": "\u001b\r"
  },
  "id": "User.sendInput.8F63D3A9"
}
```

Ensure keybindings contain:

```json
[
  {
    "id": "User.sendInput.8F63D3A9",
    "keys": "shift+enter"
  },
  {
    "id": null,
    "keys": "alt+enter"
  }
]
```

When merging, avoid duplicating equivalent keybindings. Update existing `shift+enter` and `alt+enter` entries if present.

## Validation

After editing:

- Re-read `settings.json`.
- Confirm `profiles.defaults.font.face` is `FiraCode Nerd Font Mono`.
- Confirm `FiraCode Nerd Font Mono` is installed, or clearly report the fallback risk.
- Confirm `opacity` is `40` and `useAcrylic` is `true`.
- Confirm `shift+enter` and `alt+enter` have the documented behavior.

If the font is not installed, leave the setting in place and report that Windows may fall back until the Nerd Font is installed.
