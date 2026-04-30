# Warm Sand

This bundled reference records the Warm Sand palette used by this skill.

Agents should prefer the palette embedded in `SKILL.md` when applying the theme. This file is supporting reference material for maintainers.

## Source Palette Roles

- Background family: `rgb(32, 34, 34)` to `rgb(36, 36, 36)`
- Primary readable text: `rgb(210, 196, 164)` -> `#D2C4A4`
- Brighter readable text: `rgb(235, 220, 180)` -> `#EBDCB4`
- Muted gray-green text: `rgb(160, 172, 154)` -> `#A0AC9A`
- Directory green: `rgb(118, 150, 140)` -> `#76968C`
- Highlight green: `rgb(148, 184, 154)` -> `#94B89A`
- Teal accent: `rgb(20, 170, 132)` -> `#14AA84`
- Soft warning beige: `rgb(184, 154, 96)` -> `#B89A60`
- Soft red: `rgb(196, 126, 126)` -> `#C47E7E`
- Strong red: `rgb(220, 95, 95)` -> `#DC5F5F`
- Selection block: `rgb(58, 58, 58)` -> `#3A3A3A`

## Example Windows Terminal Scheme

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

## Tuning Rules

- If gray status text is still too dim, lift `brightBlack` before touching `background`.
- If the whole terminal looks washed out, lower `brightWhite` before lowering `foreground`.
- If green accents overpower file text, reduce `green` saturation and keep `foreground` warm.
- Keep `selectionBackground` neutral; the source palette works because contrast comes from value, not saturation.
