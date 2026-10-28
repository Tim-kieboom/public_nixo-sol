-- Monitor layout of the "nixos" host (loaded by hyprland.lua).
-- Find your outputs with `hyprctl monitors`.

local mainMonitor = "HDMI-A-4"
local secondMonitor = "HDMI-A-5"
hl.monitor({
    output   = mainMonitor,
    mode     = "preferred",
    position = "0x0",
    scale    = "1.5",
})

hl.monitor({
    output   = secondMonitor,
    mode     = "preferred",
    position = "auto-left",
    scale    = "auto",
})

hl.workspace_rule({
    workspace = "1",
    monitor = secondMonitor,
    default = true,
})

hl.workspace_rule({
    workspace = "2",
    monitor = mainMonitor,
    default = true,
})
