-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1

-- GDK_SCALE=2 with GDK_DPI_SCALE=0.75 nets an effective 1.5x (matching DP-1's
-- scale below) but renders GTK3/non-fractional-scale-aware app buffers at 2x
-- pixel density, so Hyprland downsamples them to fit the screen instead of
-- upsampling a 1x buffer — downsampling looks sharp, upsampling looked
-- blurry. GDK_SCALE must stay an integer; GDK_DPI_SCALE carries the fraction.
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.env("GDK_DPI_SCALE", "0.75")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Main monitor: AOC U32G3X (4K @ 32"), at the origin. Scaled 1.5x: at
-- scale=1 this panel is ~139 PPI, making the bar/UI physically tiny;
-- 1.5x brings it to ~93 PPI, close to a normal desktop density. Logical
-- size becomes 3840/1.5 x 2160/1.5 = 2560x1440 — other monitors position
-- against that logical size, not the raw 3840x2160 pixels.
-- 60Hz, not 144: 4K@144 went to "No signal" on 2026-09-28 and 120Hz flickered
-- (DP link at its bandwidth limit). Try higher again with a certified DP 1.4 cable.
hl.monitor({ output = "DP-1", mode = "3840x2160@60", position = "0x0", scale = 1.5 })
-- Secondary: Samsung C27F390, to the right of the AOC (logical width 2560px
-- at the AOC's 1.5x scale). Bottom-aligned with the AOC (1440 - 1080 = 360)
-- so the mouse can cross from the bottom of the main monitor onto the Samsung.
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "2560x360", scale = 1 })

-- Back to Omarchy's default: force_zero_scaling = true tells XWayland
-- clients the DP-1 panel is an unscaled 3840x2160 display, so a non-DPI-
-- aware XWayland app renders at native pixel density (crisp) instead of a
-- pre-scaled 2560x1440 canvas that Hyprland then has to upsample 1.5x
-- (blurry). Previously set to `false` on the theory that DPI-aware XWayland
-- apps would size correctly against the real 1.5x scale, but the trade-off
-- bit for real: Spotify (Linux client has no native Wayland support, always
-- XWayland) confirmed via `xrandr` to be getting the pre-scaled 2560x1440
-- canvas and rendering visibly blurry. Reverted — Spotify's UI is now
-- physically small at native density instead; use its own Ctrl+= zoom (or
-- Settings) to compensate, rather than re-blurring it to get correct size.
hl.config({ xwayland = { force_zero_scaling = true } })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Pin workspaces to a monitor: 1-3 on the main AOC (DP-1), 4-6 on the
-- Samsung (HDMI-A-1). Each monitor's first pinned workspace is its default
-- so it's what greets you when the monitor connects. persistent = true keeps
-- them alive (and in the bar) even while empty and not focused — otherwise
-- Hyprland drops an empty, unfocused workspace from its list.
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", persistent = true })
