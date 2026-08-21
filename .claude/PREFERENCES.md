# System Preferences (cross-platform)

Personal desktop/editor/terminal preferences for Nicklas. Apply these by default when
setting up a new machine or touching font/theme/terminal-color settings, unless the user
says otherwise for that specific context. Source of truth for the Arch desktop's actual
values: `~/.dotfiles`' `.config/omarchy/themes/singularity-forest/` (tracked at
github.com/Zasam/dotfiles).

## Font

Primary: **Cascadia Mono / Cascadia Code**, Nerd Font-patched build ("CaskaydiaMono Nerd
Font Mono" on Linux). Chosen via a live A/B comparison against 5 other installed
monospace fonts (Aug 2026) — clear winner at 9/10.

Ranked results (worst to best):
| Font | Rating |
|---|---|
| Nimbus Mono PS | 4/10 |
| Liberation Mono | 6.5/10 |
| JetBrainsMonoNL Nerd Font Mono | 7/10 |
| Adwaita Mono | 7/10 |
| iA Writer Mono S | 8/10 |
| **CaskaydiaMono Nerd Font Mono** | **9/10 — preferred** |

JetBrainsMono Nerd Font Mono (the prior default) wasn't directly re-rated in this pass but
was the previous daily driver, so it's a safe fallback if Cascadia truly isn't installable
somewhere.

**Install per platform:**
- **Linux (Arch/Omarchy)**: `omarchy font set "CaskaydiaMono Nerd Font Mono"` — already
  applied. Underlying package is a Nerd Fonts "CascadiaMono" release.
- **Windows**: Windows Terminal ships plain "Cascadia Code"/"Cascadia Mono" by default,
  but that build has **no** icon glyphs. For the icon-patched Nerd Font version used here:
  `winget install DEVCOM.CascadiaCodeNerdFont`, or download the "CascadiaMono" zip from
  github.com/ryanoasis/nerd-fonts/releases and install the .ttf files manually. Then set
  it as the font in Windows Terminal, VS Code, and any other terminal/editor profile.
- **macOS**: `brew install --cask font-caskaydia-mono-nerd-font`.

## Color theme — dark green, not purple/blue

Preference is a dark forest-green palette over the more common purple/blue/magenta
defaults many themes ship with. Full palette below (hex), derived from the "Singularity
Forest" Omarchy theme — reuse these values (or the closest built-in theme that already
matches this hue, e.g. something in the Everforest/Osaka Jade family) when setting a
terminal color scheme, editor theme, or any other themeable app's accent colors:

| Role | Hex |
|---|---|
| Background | `#0B1710` |
| Foreground / primary accent | `#4FD98C` |
| Secondary accent | `#34A65F` |
| Cursor | `#FF7F41` (warm orange — deliberate accent, not green) |
| Selection background | `#4FD98C` |
| Selection foreground | `#0B1710` |
| ANSI black | `#000000` |
| ANSI red (errors/warnings) | `#E20342` |
| ANSI green | `#C8E967` |
| ANSI yellow | `#7CD699` |
| ANSI blue | `#34A65F` |
| ANSI magenta | `#3C8F6E` |
| ANSI cyan | `#FF7F41` |
| ANSI white | `#1D5C34` |
| Bright black | `#143A22` |
| Bright red | `#CE4F48` |
| Bright green | `#D6FF7A` |
| Bright yellow | `#FFBE74` |
| Bright blue | `#05C79A` |
| Bright magenta | `#5EE39A` |
| Bright cyan | `#37B37E` |
| Bright white | `#E9F3EC` |

Notes on intent, not just the raw values:
- Reds/warnings were deliberately kept red (not greened) — semantic error/diff coloring
  matters more than palette purity.
- The orange cursor is a deliberate single warm accent against the green background, not
  an oversight.
- When an app already ships a close-enough built-in dark-green theme (e.g. a terminal
  profile named "Everforest" or similar), prefer applying that over hand-authoring a new
  one from the table above — reuse before recreate, same reasoning used when picking this
  theme's own starting point on the Arch desktop.

## Applying this on a new machine

1. Font first (see install steps above), then color theme.
2. For an app with real theme support (Windows Terminal, VS Code, a Nerd-Font-aware
   terminal), build/select a color scheme from the hex table above rather than leaving the
   app's purple/blue default.
3. Confirm with the user before doing a large, hard-to-reverse setup step (e.g. installing
   many fonts/extensions) — this file states *preferences*, not blanket permission to
   modify a machine unattended.
