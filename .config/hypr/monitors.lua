-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Main monitor: AOC U32G3X (4K @ 32"), at the origin. Scaled 1.5x: at
-- scale=1 this panel is ~139 PPI, making the bar/UI physically tiny;
-- 1.5x brings it to ~93 PPI, close to a normal desktop density. Logical
-- size becomes 3840/1.5 x 2160/1.5 = 2560x1440 — other monitors position
-- against that logical size, not the raw 3840x2160 pixels.
hl.monitor({ output = "DP-1", mode = "3840x2160@144", position = "0x0", scale = 1.5 })
-- Secondary: Samsung C27F390, to the right of the AOC (logical width 2560px
-- at the AOC's 1.5x scale). Bottom-aligned with the AOC (1440 - 1080 = 360)
-- so the mouse can cross from the bottom of the main monitor onto the Samsung.
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "2560x360", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
