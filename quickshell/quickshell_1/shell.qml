//@ pragma UseQApplication

import "modules/bar"
import "modules/panel"
import "modules/osd"
import "modules/panel/notifications"

import QtQuick
import Quickshell
import Quickshell.Io
import qs.service

ShellRoot {

    Component.onCompleted: NotificationService.defaultTimeout

    IpcHandler {
        target: "controls"

        function toggle(): void {
            GlobalStates.controlsVisible = !GlobalStates.controlsVisible;
        }

        function open(): void {
            GlobalStates.controlsVisible = true;
        }

        function close(): void {
            GlobalStates.controlsVisible = false;
        }
    }

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            GlobalStates.wallpaperSwitcherVisible = !GlobalStates.wallpaperSwitcherVisible;
        }

        function open(): void {
            GlobalStates.wallpaperSwitcherVisible = true;
        }

        function close(): void {
            GlobalStates.wallpaperSwitcherVisible = false;
        }
    }

    Bar {}

    Controls {}
    BrightnessOsd {}
    VolumeOsd {}
    WallpaperSwitcher {}
    NotificationPopup {}
}
