# dotfiles

Bare repo at `~/.dotfiles` with `$HOME` as its work tree — use the `dot` alias instead of
`git` (`dot status`, `dot add <file>`, `dot commit`). Desktop: Omarchy (Hyprland) on Arch.
Private notes (`~/.claude/TODO.md`, `NETWORK.md`) sync via Nextcloud and are never tracked.

This file is the cheat-sheet for everything custom in here: one line per script, alias,
binding and bar module. Add a line in the same commit that adds the thing.

## Scripts (`~/.local/bin`)

| Command | What it does |
|---|---|
| `laptop-desktop [output…]` | Opens omarchy-predator's running session in VNC viewers, one window per monitor, over an SSH tunnel (LAN only). Also in the app launcher as "Laptop Desktop" (failures → notification + `journalctl -t laptop-desktop`). Use Super+Shift+Esc to pass keys through. |
| `huion-pad-keys` | Maps the Huion WH1409's 12 express keys to LibreSprite shortcuts via a virtual keyboard. Runs as `huion-pad-keys.service` (user), needs `.config/huion-pad-keys/70-huion-pad.rules` in `/etc/udev/rules.d/`. |

## Shell (`.bashrc`)

| Alias / function | What it does |
|---|---|
| `dev` | `cd ~/dev/projects` |
| `dot` | git for this repo |
| `fcd` | fuzzy-pick a directory (fd + fzf) and `cd` into it |
| `claude` | wrapper: refuses to start in `~/dev` or `~/dev/releases` |
| `atlas-deploy`, `agent-deploy` | run ATLAS's `atlas/deploy.sh` / `agent/deploy.sh` |
| `sshadd` | `ssh-add ~/.ssh/id_ed25519` |
| `lg` · `vim` · `tmux` | lazygit · nvim · zellij (`command tmux` for the real one) |
| `dr` `dw` `db` `bp-linux64` · `cr` | dotnet run/watch/build/publish -r · cargo run |
| `files` · `data` · `q` | open cwd in the file manager · `~/Data` · exit |

Machine-only overrides go in `~/.bashrc.local` (untracked); secrets in `~/.bash_secrets`.

## Keybindings (`.config/hypr/bindings.lua`)

Super+K lists every binding with its description, custom ones included.

| Keys | What it does |
|---|---|
| Super+Alt+V / Super+Shift+V | start / stop the voice pipeline (`voice-assistant/scripts/lva-control.py`) |
| Super+Shift+Esc | toggle key pass-through: no desktop binding fires, keys go to the focused window (e.g. laptop-desktop's VNC) |

## Bar modules (`.config/omarchy/shell.json`, scripts in `.config/omarchy/bar/scripts/`)

| Module | What it shows |
|---|---|
| `habits` | today's Atlas habits (`atlas-env.sh` holds Atlas's address for all Atlas modules) |
| `servers` | reachability of the home services; click opens a picker |
| `project` | the last shell's project dir + git branch; click opens a terminal there |
| `pomodoro` | 25/5/15 Pomodoro timer; click toggles, `pomodoro-reset.sh` resets |
| `resources` | CPU + RAM |
| `kdeconnect` | paired phone's reachability + battery |
| `screentime` | today's active screen time from Atlas; tooltip: right now, vs. 7-day average, categories, top apps/sites; click opens Atlas › Screen time |

## Launcher entries (`.local/share/applications/`)

`laptop-desktop.desktop` — see Scripts.
