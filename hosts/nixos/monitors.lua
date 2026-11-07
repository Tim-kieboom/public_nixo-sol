-- Monitor layout of the "nixos" host (loaded by hyprland.lua).
-- Find your outputs with `hyprctl monitors`.

-- preferre gpu-a over gpu-b
hl.env("AQ_DRM_DEVICES", "/dev/dri/gpu-a:/dev/dri/gpu-b")


local mainMonitor = "HDMI-A-4"
local secondMonitor = "HDMI-A-5"
hl.monitor({
    output   = mainMonitor,
    mode     = "preferred",
    position = "0x0",
    scale    = "1.67",
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
