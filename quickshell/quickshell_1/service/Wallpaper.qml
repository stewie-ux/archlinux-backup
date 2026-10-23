pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string wallpaperDir: Quickshell.env("HOME") + "/.local/share/wallpapers/"
    property string stateFile: Quickshell.env("HOME") + "/.local/state/quickshell/wallpaper.txt"

    property var transitionTypes: ["grow", "outer", "wave", "any"]

    function pickRandomTransition() {
        return transitionTypes[Math.floor(Math.random() * transitionTypes.length)];
    }

    property var wallpapers: []
    property int selectedIndex: 0
    property string currentWallpaper: ""

    function scan() {
        scanProcess.running = false;
        scanProcess.running = true;
    }

    Process {
        id: scanProcess
        command: ["bash", "-c", "find '" + root.wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' \\) | sort"]
        stdout: StdioCollector {
            onStreamFinished: {
                const list = text.trim().length > 0 ? text.trim().split("\n") : [];
                root.wallpapers = list;
                const idx = list.indexOf(root.currentWallpaper);
                root.selectedIndex = idx >= 0 ? idx : 0;
            }
        }
    }

    FileView {
        id: stateFileView
        path: root.stateFile
        printErrors: false

        onLoaded: {
            const saved = text().trim();
            if (saved.length > 0) {
                root.currentWallpaper = saved;
            }
        }

        onLoadFailed: function (error) {
        // File doesn't exist yet (first run) — that's fine, ignore it.
        }
    }

    Process {
        id: applyProcess
        command: ["bash", "-c", ""]
    }

    Process {
        id: saveStateProcess
        command: ["bash", "-c", ""]
    }

    function applyWallpaper(path) {
        if (!path)
            return;
        root.currentWallpaper = path;
        saveStateProcess.command = ["bash", "-c", "mkdir -p \"$(dirname '" + root.stateFile + "')\" && printf '%s' '" + path + "' > '" + root.stateFile + "'"];
        saveStateProcess.running = false;
        saveStateProcess.running = true;

        // const script = "awww img '" + path + "' " + "--transition-type random " + "--transition-fps 60 " + "--transition-duration 2.2 && " + "matugen image '" + path + "' -m dark --source-color-index 1";
        const transition = root.pickRandomTransition();
        const script = "awww img '" + path + "' " + "--transition-type " + transition + " " + "--transition-fps 144 " + "--transition-duration 2.2 && " + "matugen image '" + path + "' -m dark --source-color-index 0";

        applyProcess.command = ["bash", "-c", script];
        applyProcess.running = false;
        applyProcess.running = true;
    }

    function selectAndApply() {
        if (wallpapers.length === 0)
            return;
        applyWallpaper(wallpapers[selectedIndex]);
    }

    Component.onCompleted: scan()
}
