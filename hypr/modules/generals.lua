-- Monitors configurations
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1.0",
})


---------------
---- INPUT ----
---------------

-- Keyboard configurations
hl.config({
    input = {
        kb_layout     = "us",
        kb_variant    = "",
        kb_model      = "",
        kb_options    = "",
        kb_rules      = "",

        follow_mouse  = 1,
        sensitivity   = 0, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        touchpad      = {
            natural_scroll = true,
        },
    },
})

-- Touchpad
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


-- Mouse
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more

-- This two is my mouse, "2.4g-mouse" & "cb-raptor-mouse"
hl.device({
    name          = "2.4g-mouse",
    sensitivity   = -0.2,
    accel_profile = "flat",
})

hl.device({
    name          = "cb-raptor-mouse",
    sensitivity   = -0.2,

    -- Mouse Acceleration
    accel_profile = "flat",
})


-- Miscellaneous configurations
hl.config({
    misc = {
        force_default_wallpaper = 1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true -- this removes the text(cote)
    },
})
