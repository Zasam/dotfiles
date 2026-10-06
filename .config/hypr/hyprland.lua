-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.

-- Android emulator (scripts/run boots it for `npx expo run:android`): float
-- instead of tiling, sized as a share of monitor height so it reads as a
-- phone on anything from the 1080p Samsung to the 4K AOC. WM_CLASS is
-- "Emulator" (confirmed live, not "qemu" as originally guessed below) —
-- title-match it too so this doesn't also grab the small floating toolbar
-- window the emulator opens alongside it (same class, title "Emulator").
o.window({ class = "^Emulator$", title = "^Android Emulator" }, {
  float = true,
  center = true,
  size = { "(monitor_h*9/25)", "(monitor_h*4/5)" },
  keep_aspect_ratio = true,
})
