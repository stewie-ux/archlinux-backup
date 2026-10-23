-- Autostart configurations
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    -- Autostart apps list
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- hl.exec_cmd("qs -p .config/Playground/quickshell_1/")
    -- hl.exec_cmd("wl-paste --watch cliphist store")
end)
