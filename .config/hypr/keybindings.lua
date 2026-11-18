-- Keybindings for hyprland

---------------------
---- KEYBINDINGS ----
---------------------

local v = require("variables")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local function key(mods, k)
    return mods .. " + " .. k
end

local MOD       = mainMod
local MOD_SHIFT = mainMod .. " + SHIFT"

-- --- Core Launchers
hl.bind(key(MOD, "Return"), hl.dsp.exec_cmd(v.terminal))
hl.bind(key(MOD, "E"),      hl.dsp.exec_cmd(v.fileManager))
hl.bind(key(MOD, "R"),      hl.dsp.exec_cmd("pkill rofi || ~/.config/rofi/launchers/type-2/launcher.sh"))
hl.bind(key(MOD, "B"),      hl.dsp.exec_cmd(v.browser)) -- Execute firefox

hl.bind(key(MOD_SHIFT, "R"), hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))
hl.bind(key(MOD_SHIFT, "W"), hl.dsp.exec_cmd("~/.local/bin/awww-restore.sh"))

-- Rotate the monitor
hl.bind(key(MOD_SHIFT, "M"), hl.dsp.exec_cmd("~/.local/bin/toggle-rotate-hdmi.sh"))


-- --- Kill processes
hl.bind(key(MOD, "Q"),       hl.dsp.window.close()) -- killactive
hl.bind(key(MOD_SHIFT, "Q"), hl.dsp.window.kill())  -- forcekillactive

hl.bind(key(MOD, "M"), hl.dsp.exit()) -- Exit hyprland


-- --- Fullscreen/floating/minimize functionality
hl.bind(key(MOD, "F"),       hl.dsp.window.fullscreen({ mode = "maximized" })) -- fullscreen, 1
hl.bind(key(MOD_SHIFT, "F"), hl.dsp.window.float({ action = "toggle" }))
hl.bind(key(MOD, "P"),       hl.dsp.window.pseudo())       -- dwindle
hl.bind(key(MOD, "O"),       hl.dsp.layout("togglesplit")) -- dwindle


-- Move focus with mainMod + arrow keys / vim keys
-- Move windows with mainMod + SHIFT + arrow keys / vim keys
local directions = {
    { arrow = "left",  shift_arrow = "Left",  vim = "H", dir = "left"  },
    { arrow = "right", shift_arrow = "Right", vim = "L", dir = "right" },
    { arrow = "up",    shift_arrow = "Up",    vim = "K", dir = "up"    },
    { arrow = "down",  shift_arrow = "Down",  vim = "J", dir = "down"  },
}

for _, d in ipairs(directions) do
    hl.bind(key(MOD, d.arrow),             hl.dsp.focus({ direction = d.dir }))
    hl.bind(key(MOD, d.vim),               hl.dsp.focus({ direction = d.dir }))
    hl.bind(key(MOD_SHIFT, d.vim),         hl.dsp.window.move({ direction = d.dir }))
    hl.bind(key(MOD_SHIFT, d.shift_arrow), hl.dsp.window.move({ direction = d.dir }))
end


-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local k = tostring(i % 10) -- 10 maps to key 0
    hl.bind(key(MOD, k),       hl.dsp.focus({ workspace = i }))
    hl.bind(key(MOD_SHIFT, k), hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(key(MOD, "S"),       hl.dsp.workspace.toggle_special("magic"))
hl.bind(key(MOD_SHIFT, "S"), hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(key(MOD, "mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key(MOD, "mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(key(MOD, "mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key(MOD, "mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness (bindel)
local media_repeat = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media_repeat)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      media_repeat)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     media_repeat)
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   media_repeat)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  media_repeat)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  media_repeat)

-- Requires playerctl (bindl)
local media = { locked = true }
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       media)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), media)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), media)
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   media)

-- Notifications center (swaync)
hl.bind(key(MOD, "N"), hl.dsp.exec_cmd("swaync-client -t"))
