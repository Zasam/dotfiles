-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Manual override for the voice assistant (linux-voice-assistant), for when a
-- misheard wake word leaves it stuck listening/thinking with no voice command
-- that can reach it. See ~/dev/projects/voice-assistant/scripts/lva-control.py.
o.bind("SUPER + SHIFT + V", "Stop voice pipeline", "~/dev/projects/voice-assistant/scripts/lva-control.py stop")
o.bind("SUPER + ALT + V", "Start voice pipeline", "~/dev/projects/voice-assistant/scripts/lva-control.py start")

-- Key pass-through, mainly for laptop-desktop's VNC windows: in the "passthru" submap no
-- desktop binding fires, so Omarchy shortcuts (Super+W, …) reach the focused window and
-- through VNC the laptop. The same key leaves it; it's the only binding that stays live.
local function set_passthru(on)
  return function()
    hl.dispatch(hl.dsp.submap(on and "passthru" or "reset"))
    hl.exec_cmd(o.notify(on and "Key pass-through ON (Super+Shift+Esc to leave)" or "Key pass-through off"))
  end
end
hl.define_submap("passthru", function()
  hl.bind("SUPER + SHIFT + ESCAPE", set_passthru(false), { description = "Leave key pass-through" })
end)
hl.bind("SUPER + SHIFT + ESCAPE", set_passthru(true), { description = "Pass keys to focused window" })
