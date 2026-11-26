------------------
---- MONITORS ----
------------------

-- monitors and workspace placement are per machine: ~/.config/hypr/monitors.lua
-- (from hosts/<name>/monitors.lua in the nixos repo)
local ok, err = pcall(require, "monitors")
if not ok then
    hl.exec_cmd("notify-send 'Hyprland' 'monitors.lua failed: " .. tostring(err) .. "'")
end

---------------------
---- MY PROGRAMS ----
---------------------

-- Sets "Windows" key as main modifier
local mainMod = "SUPER"
local function new_keybind(key, addKey)
    if addKey == nil then
        return mainMod .. " + " .. key
    else
        return mainMod .. " + " .. addKey .. " + " .. key
    end
end

-- Set programs that you use
local raw_editor  = "trcode"
local terminal    = "kitty"
local editor      = terminal .. " trcode -r"
local editNixos   = terminal .. " " .. raw_editor .. " /etc/nixos"
local fileManager = "thunar"
local menu        = "wofi --show drun --style ~/.local/state/theme/wofi.css"
local browser     = "brave"
local notes       = "obsidian"
local music       = "spotify"
local ai          = "claude-desktop"
local copyHistory = "~/.local/bin/cliphist-paste.sh"
local tts         = "flatpak run net.mkiol.SpeechNote"
local game        = "steam"
local lockscreen  = "sol-shell ipc call lock lock"

local keybinds    = {
    logout = new_keybind("M", "SHIFT"),
    lockscreen = new_keybind("L", "SHIFT"),

    terminal = new_keybind("Q"),
    editNixos = new_keybind("Q", "SHIFT"),

    files = new_keybind("E"),
    menu = new_keybind("R"),
    notes = new_keybind("N"),
    browser = new_keybind("B"),
    editor = new_keybind("Z"),
    ai = new_keybind("A"),
    game = new_keybind("G"),

    audio = {
        vulumeUp = new_keybind("equal"),
        vulumeDown = new_keybind("minus"),
        mute = new_keybind("M"),
    },

    music = {
        openMusicApp = new_keybind("S"),
        prevTrack = new_keybind("minus", "SHIFT"),
        nextTrack = new_keybind("equal", "SHIFT"),
        play = new_keybind("bracketleft"),
        stop = new_keybind("bracketright"),
    },

    screenshot = new_keybind("P"),
    screenshotRegion = new_keybind("S", "SHIFT"),

    copyHistory = new_keybind("V"),
    TTS = new_keybind("T"),

    window = {
        close = new_keybind("C"),
        windowFloat = new_keybind("F"),

        toggleSplit = new_keybind("J"),

        focusLeft = new_keybind("left"),
        focusRight = new_keybind("right"),
        focusUp = new_keybind("up"),
        focusDown = new_keybind("down"),

        moveLeft = new_keybind("left ", "SHIFT"),
        moveRight = new_keybind("right", "SHIFT"),
        moveUp = new_keybind("up   ", "SHIFT"),
        moveDown = new_keybind("down ", "SHIFT"),

        drag = new_keybind("mouse:272"),
        resize = new_keybind("mouse:273"),
    },
}

-------------------
---- AUTOSTART ----
-------------------
-- SHOULD BE FIRST
do
    local start_file_portal    = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

    local run_status_bar       = "sol-shell"
    local run_hypr_agent       = "systemctl --user start hyprpolkitagent"
    local add_cliphist_image   = "wl-paste --type image --watch cliphist store"
    local add_cliphist_watcher = "wl-paste --type text --watch cliphist store"

    local headphone_MAC        = "00:0A:45:4C:4E:8D"
    local turn_bluetooth_on    = "bluetoothctl power on"
    local trust_headphone      = "bluetoothctl trust " .. headphone_MAC
    local connect_headphone    = "bluetoothctl connect " .. headphone_MAC

    hl.on("hyprland.start", function()
        hl.exec_cmd(table.concat({ turn_bluetooth_on, "sleep 3", trust_headphone, connect_headphone }, " && "))
        hl.exec_cmd(start_file_portal)

        hl.exec_cmd(run_status_bar)
        hl.exec_cmd(run_hypr_agent)
        hl.exec_cmd(add_cliphist_image)
        hl.exec_cmd(add_cliphist_watcher)
    end)
end

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------
do
    local function curves(entries)
        for _, entry in ipairs(entries) do
            hl.curve(entry[1], entry[2])
        end
    end

    hl.config({
        general = {
            gaps_in          = 5,
            gaps_out         = 20,

            border_size      = 2,

            col              = {
                -- { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
                active_border   = "rgb(c7c896)",
                inactive_border = "rgba(595959aa)",
            },

            -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = false,

            -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
            allow_tearing    = false,

            layout           = "dwindle",
        },

        decoration = {
            rounding         = 10,
            rounding_power   = 2,

            -- Change transparency of focused and unfocused windows
            active_opacity   = 1.0,
            inactive_opacity = 1.0,

            shadow           = {
                enabled      = true,
                range        = 4,
                render_power = 3,
                color        = 0xee1a1a1a,
            },

            blur             = {
                enabled  = true,
                size     = 8,
                passes   = 3,
                vibrancy = 0.1696,
            },
        },

        animations = {
            enabled = true,
        },
    })

    curves({
        -- Default curves and animations
        { "easeOutQuint",   { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } } },
        { "easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } } },
        { "linear",         { type = "bezier", points = { { 0, 0 }, { 1, 1 } } } },
        { "almostLinear",   { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } } },
        { "quick",          { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } } },

        -- Default springs
        { "easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 } },
    })

    local function animations(entries)
        for i, entry in ipairs(entries) do
            assert(type(entry) == "table",
                "entry[" .. i .. "] is " .. type(entry) .. ", not table")
            hl.animation(entry)
        end
    end

    animations({
        { leaf = "global",        enabled = true, speed = 10,   bezier = "default" },
        { leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" },
        { leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" },
        { leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" },
        { leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" },
        { leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" },
        { leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" },
        { leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" },
        { leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" },
        { leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" },
        { leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" },
        { leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" },
        { leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" },
        { leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" },
        { leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" },
        { leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" },
        { leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" },
    })

    hl.config({
        dwindle = {
            preserve_split = true,
        },
    })
end
----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


---------------------
---- KEYBINDINGS ----
---------------------
do
    local function bindings(entries)
        for _, entry in ipairs(entries) do
            hl.bind(entry[1], entry[2], entry[3])
        end
    end

    local locked = { locked = true }
    local lockRepeating = { locked = true, repeating = true }
    local playerctl = "playerctl --player=" .. music
    local logoutCmd = "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"

    -- ─── Switch-Workspace  ─────────────────────────────────────────────────────
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        bindings({
            { new_keybind(key),          hl.dsp.focus({ workspace = i }) },
            { new_keybind(key, "SHIFT"), hl.dsp.window.move({ workspace = i }) },
        })
    end

    bindings({
        -- ─── System ────────────────────────────────────────────────────────────────
        { keybinds.logout,             hl.dsp.exec_cmd(logoutCmd) },
        { keybinds.lockscreen,         hl.dsp.exec_cmd(lockscreen) },

        -- ─── Apps ──────────────────────────────────────────────────────────────────
        { keybinds.terminal,           hl.dsp.exec_cmd(terminal) },
        { keybinds.editNixos,          hl.dsp.exec_cmd(editNixos) },
        { keybinds.files,              hl.dsp.exec_cmd(fileManager) },
        { keybinds.menu,               hl.dsp.exec_cmd(menu) },
        { keybinds.notes,              hl.dsp.exec_cmd(notes) },
        { keybinds.browser,            hl.dsp.exec_cmd(browser) },
        { keybinds.editor,             hl.dsp.exec_cmd(editor) },
        { keybinds.ai,                 hl.dsp.exec_cmd(ai) },
        { keybinds.game,               hl.dsp.exec_cmd(game) },

        -- ─── Window ────────────────────────────────────────────────────────────────
        { keybinds.window.close,       hl.dsp.window.close() },
        { keybinds.window.windowFloat, hl.dsp.window.float({ action = "toggle" }) },
        { keybinds.window.toggleSplit, hl.dsp.layout("togglesplit") },
        { keybinds.window.focusLeft,   hl.dsp.focus({ direction = "left" }) },
        { keybinds.window.focusRight,  hl.dsp.focus({ direction = "right" }) },
        { keybinds.window.focusUp,     hl.dsp.focus({ direction = "up" }) },
        { keybinds.window.focusDown,   hl.dsp.focus({ direction = "down" }) },
        { keybinds.window.moveLeft,    hl.dsp.window.move({ direction = "left" }) },
        { keybinds.window.moveRight,   hl.dsp.window.move({ direction = "right" }) },
        { keybinds.window.moveUp,      hl.dsp.window.move({ direction = "up" }) },
        { keybinds.window.moveDown,    hl.dsp.window.move({ direction = "down" }) },

        -- ─── Scoll-Workspace  ─────────────────────────────────────────────────────
        { new_keybind("mouse_down"),   hl.dsp.focus({ workspace = "e+1" }) },
        { new_keybind("mouse_up"),     hl.dsp.focus({ workspace = "e-1" }) },

        -- ─── Audio ─────────────────────────────────────────────────────────────────
        { "XF86AudioRaiseVolume",      hl.dsp.exec_cmd("sol-shell ipc call osd volumeUp") },
        { "XF86AudioLowerVolume",      hl.dsp.exec_cmd("sol-shell ipc call osd volumeDown") },
        { "XF86AudioMute",             hl.dsp.exec_cmd("sol-shell ipc call osd mute") },
        { keybinds.audio.vulumeUp,     hl.dsp.exec_cmd("sol-shell ipc call osd volumeUp") },
        { keybinds.audio.vulumeDown,   hl.dsp.exec_cmd("sol-shell ipc call osd volumeDown") },
        { keybinds.audio.mute,         hl.dsp.exec_cmd("sol-shell ipc call osd mute") },

        -- ─── Music ─────────────────────────────────────────────────────────────────
        { keybinds.music.openMusicApp, hl.dsp.exec_cmd(music) },
        { keybinds.music.prevTrack,    hl.dsp.exec_cmd(playerctl .. " previous") },
        { keybinds.music.nextTrack,    hl.dsp.exec_cmd(playerctl .. " next") },
        { keybinds.music.play,         hl.dsp.exec_cmd(playerctl .. " play") },
        { keybinds.music.stop,         hl.dsp.exec_cmd(playerctl .. " stop") },

        -- ─── Misc ──────────────────────────────────────────────────────────────────
        { keybinds.screenshot,         hl.dsp.exec_cmd("hyprshot -m output") },
        { keybinds.screenshotRegion,   hl.dsp.exec_cmd("hyprshot -m region") },
        { keybinds.copyHistory,        hl.dsp.exec_cmd(copyHistory) },
        { keybinds.TTS,                hl.dsp.exec_cmd(tts) },

        -- ─── Mic  ─────────────────────────────────────────────────────
        { "XF86AudioMicMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), lockRepeating },

        -- ─── Brightness  ─────────────────────────────────────────────────────
        { "XF86MonBrightnessUp",       hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                lockRepeating },
        { "XF86MonBrightnessDown",     hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                lockRepeating },

        -- ─── AudioPlayer  ─────────────────────────────────────────────────────
        { "XF86AudioNext",             hl.dsp.exec_cmd("playerctl next"),                               locked },
        { "XF86AudioPause",            hl.dsp.exec_cmd("playerctl play-pause"),                         locked },
        { "XF86AudioPlay",             hl.dsp.exec_cmd("playerctl play-pause"),                         locked },
        { "XF86AudioPrev",             hl.dsp.exec_cmd("playerctl previous"),                           locked },
    })

    -- Laptop multimedia keys for volume and LCD brightness
    -- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    --     { locked = true, repeating = true })
    -- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    --     { locked = true, repeating = true })
    -- hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    --     { locked = true, repeating = false })
end

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Steam games (Proton/XWayland, class steam_app_<id>): never float, always tile/fullscreen
hl.window_rule({
    name       = "steam-games-tile",
    match      = { class = "^steam_app_.*$" },

    tile       = true,
    fullscreen = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- sol-shell: blur what shows through the see-through Wofi launcher. Thunar and Zen
-- are normal windows, which Hyprland blurs by itself wherever they are translucent.
-- The opacity itself is the "backgroundOpacity" setting of sol-shell.
hl.layer_rule({
    name         = "blur-wofi",
    match        = { namespace = "^wofi$" },

    blur         = true,
    ignore_alpha = 0.1,
})
