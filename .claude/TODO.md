# Global To-Dos

Cross-project/machine-setup items that came up in a session but weren't finished on the
spot — not tied to any one repo, so they don't belong in a project's own TODO/issues.
Check this file when picking up loose ends; remove an item once it's actually done.

- [ ] Main monitor (AOC U32G3X on DP-1, RTX 2060 Super) — 4K@144 suddenly went "No
      signal" on 2026-09-28 after working ~2 weeks; 4K@120 showed a picture but
      flickered; 4K@60 is stable and is what `~/.config/hypr/monitors.lua` now sets
      (uncommitted in the dotfiles repo). No software/driver change around the failure →
      DP link at its bandwidth limit. Next: try the old cable, the other DP port on the
      GPU, the monitor OSD (DP version = 1.4, factory reset), or a VESA-certified DP 1.4
      ("DP8K") cable; then test live with
      `hyprctl eval 'hl.monitor({ output = "DP-1", mode = "3840x2160@144", position = "0x0", scale = 1.5 })'`
      and only put 120/144 back in `monitors.lua` once it runs without flicker.
- [ ] Custom pixel-art keychain, needed by **Fri 2026-10-09** — decided (2026-10-05) to
      DIY it with either **shrink film** (inkjet Schrumpffolie: print, cut, punch hole,
      bake → shrinks to ~40%, crisp pixels; Müller/Idee/Amazon Prime) or **Hama beads**
      (1 bead = 1 pixel; Müller/Action/Tedi). Mail-order ruled out: no German shop
      delivers a custom-cut one by Friday (ButtonOrder express 3–4 days, ~40€).
      Nicklas is comparing the two on the evening of 2026-10-05.
- [x] Revert manual DNS override on desktop (`enp34s0`, "Wired connection 1") back to
      DHCP — done 2026-09-14, now resolving via DHCP-provided `192.168.178.41` (Pi-hole).
- [x] Router DNS field — switched to custom DNS pointed at the Pi-hole (`pi3`,
      `192.168.178.41`) on 2026-09-14. See `NETWORK.md`.

