-- #######################################################################################
-- lazzy07's hyprland configurations Version 2 (Lua)
-- #######################################################################################
--
-- Hyprland loads this file instead of hyprland.conf whenever it exists.
-- `require("name")` loads ./name.lua from this directory.
--
-- Generated files (edit the generator, not the file):
--   colors.lua      <- matugen       (~/.config/matugen/templates/hyprland-colors.lua)
--   monitors.lua    <- nwg-displays
--   workspaces.lua  <- nwg-displays
--
-- Check this config without restarting:  Hyprland --verify-config -c ~/.config/hypr/hyprland.lua
-- Errors in the running session:         hyprctl configerrors
--
-- If a required file is broken, Hyprland shows the error, gives require() an
-- empty table, and still applies the rest of the config.


----------------------
---- SOURCE FILES ----
----------------------

local colors = require("colors") -- matugen palette, follows the wallpaper
require("monitors")              -- nwg-displays
require("workspaces")            -- nwg-displays
require("keybindings")           -- uses variables.lua
require("autostart")             -- waybar, awww, swaync, hypridle, applets, ...
require("huion-keydial")

-- Fallbacks are used while colors.lua is missing or broken (Clearnight palette).
local function color(name, fallback)
    return colors[name] or fallback
end


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GTK_THEME", "adw-gtk3-dark")
hl.env("NVD_BACKEND", "direct")


-----------------------
----- PERMISSIONS -----
-----------------------

-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 5,
        border_size = 2,

        col = {
            active_border = {
                colors = {
                    color("primary",   "rgba(aec6ffff)"),
                    color("secondary", "rgba(bfc6dcff)"),
                    color("tertiary",  "rgba(debcdfff)"),
                },
                angle = 45,
            },
            inactive_border = color("outline_variant", "rgba(44474fff)"),
        },

        resize_on_border = false,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding         = 8,
        rounding_power   = 2,
        active_opacity   = 0.97,
        inactive_opacity = 0.97,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            new_optimizations = true,
            xray              = true,
            noise             = 0.08,
        },
    },

    animations = {
        enabled = true, -- yes, please :)
    },
})

-- swaync layers
hl.layer_rule({ match = { namespace = "swaync-control-center" },      blur = false })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = false })
hl.layer_rule({ match = { namespace = "swaync-control-center" },      ignore_alpha = 0.5 })

--         NAME,                                    X0,   Y0,      X1,   Y1
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        vrr                     = 0,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Example per-device config
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "windowrule-1",
    match = { class = "^(blender)$" },

    no_blur = true,
    opaque  = true,
})
