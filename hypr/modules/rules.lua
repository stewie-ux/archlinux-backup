-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

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

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})



-- THESE ARE MY Configurings --

-- VS Codium --
hl.window_rule({
  match   = { class = "^(codium)$" },
  opacity = "1 override 1 override 1.0 override",
  float   = false,
})

-- Android Studio --
hl.window_rule({
  match   = { class = "^(jetbrains-studio)$", title = "Welcome to Android Studio" },
  opacity = "0.9 override 0.9 override 1.0 override",
  float   = true,
  size    = { 800, 650 },
  center  = true
})

-- ZEN Browser --
-- hl.window_rule({
--   match   = { class = "^(zen)$" },
--   opacity = "0.9 override 0.7 override 1.0 override",
--   float   = false,
-- })

-- kcm_bluetooth --
hl.window_rule({
  match   = { class = "^(kcm_bluetooth)$" },
  opacity = "0.7 override 0.7 override 1.0 override",
  float   = true,
  size    = { 460, 360 },
  center  = true
})

-- Nautilus --
hl.window_rule({
  match   = { class = "^(org.gnome.Nautilus)$" },
  opacity = "1 override 1 override 1.0 override",
  float   = true,
  size    = { 680, 520 },
  center  = true
})

-- GTK FilePicker --
hl.window_rule({
  match   = { class = "^(xdg-desktop-portal-gtk)$" },
  opacity = "0.8 override 0.8 override 1.0 override",
  float   = true,
  size    = { 800, 600 },
  center  = true
})


-- ================================== --
-- ===== THIS ARE NOT PERMANENT ===== --
-- ================================== --

hl.layer_rule({
  match        = { namespace = "quickshell:bar" },
  blur         = true,
  ignore_alpha = 0.3,
})

hl.layer_rule({
  match        = { namespace = "quickshell:Controls" },
  blur         = true,
  ignore_alpha = 0.0,
  animation    = "slide right"
})

hl.layer_rule({
  match        = { namespace = "quickshell:VolumeOSD" },
  blur         = true,
  ignore_alpha = 0.0,
  animation    = "slide bottom"
})

hl.layer_rule({
  match        = { namespace = "quickshell:BrightnessOSD" },
  blur         = true,
  ignore_alpha = 0.0,
  animation    = "slide bottom"
})

hl.layer_rule({
  match        = { namespace = "quickshell:WallpaperSwitcher" },
  blur         = true,
  ignore_alpha = 0.0,
  animation    = "slide top"
})

-- Enable blur and ignore_alpha (for QuickShell)
-- This are just temporary

-- Example

-- hl.layer_rule({
--   match        = { namespace = "quickshell:ControlPanel" },
--   blur         = false,
--   ignore_alpha = 0.0,
--   animation    = "slide right"
-- })
