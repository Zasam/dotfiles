# Global To-Dos

Cross-project/machine-setup items that came up in a session but weren't finished on the
spot — not tied to any one repo, so they don't belong in a project's own TODO/issues.
Check this file when picking up loose ends; remove an item once it's actually done.

- **Back up `~/.bash_secrets`** (`NUGET_API_KEY`, `HA_TOKEN`) somewhere durable (password
  manager). Deliberately kept outside the `~/.dotfiles` repo (see
  `~/.bashrc`'s `[ -f "$HOME/.bash_secrets" ] && source ...` line and
  `~/.dotfiles/info/exclude`), so it has no other backup — if this machine is lost, it's
  lost too.

- **Port waybar customizations to the new Omarchy shell** (post Omarchy Quattro upgrade,
  2026-09-02). Quattro removed waybar entirely (`pacman -Q waybar` → not installed),
  replaced by a Quickshell-based bar configured via `~/.config/omarchy/shell.json` +
  built-in widgets (`omarchy.agents`, `omarchy.weather`, `omarchy.system-update`, etc.).
  Old waybar config can't be reloaded as-is. The original scripts are still tracked in
  `~/.dotfiles` at `.config/waybar/scripts/` (pomodoro, weather, git status, kdeconnect,
  habits, servers, focus tracking, media, clipboard, updates, project) — porting means
  rewriting each as a shell plugin (`omarchy plugin clone <id>`, then edit; see the
  `omarchy` skill's `plugins.md`), not a straight copy. Also on the list: browse what's
  new in the Quattro bar/shell before deciding what to keep vs. replace.
