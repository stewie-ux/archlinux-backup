// pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs
import qs.service
import qs.modules.common

PanelWindow {
    id: root

    readonly property int thumbWidth: 360

    visible: GlobalStates.wallpaperSwitcherVisible

    anchors {
        bottom: false
        left: true
        right: true
        top: true
    }

    implicitHeight: 320
    exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:WallpaperSwitcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: GlobalStates.wallpaperSwitcherVisible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    color: "transparent"

    MouseArea {
        anchors.fill: parent
        onClicked: GlobalStates.wallpaperSwitcherVisible = false
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: Math.min(1920, root.width - 40)
        height: 300
        radius: 16
        color: Qt.alpha(Colors.md3.background, 0.3)
        border.color: Qt.alpha(Colors.md3.on_primary, 0.08)
        border.width: 1

        focus: true
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Right) {
                Wallpaper.selectedIndex = Math.min(Wallpaper.selectedIndex + 1, Wallpaper.wallpapers.length - 1);
                event.accepted = true;
            } else if (event.key === Qt.Key_Left) {
                Wallpaper.selectedIndex = Math.max(Wallpaper.selectedIndex - 1, 0);
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                Wallpaper.selectAndApply();
                GlobalStates.wallpaperSwitcherVisible = false;
                event.accepted = true;
            } else if (event.key === Qt.Key_Escape) {
                GlobalStates.wallpaperSwitcherVisible = false;
                event.accepted = true;
            }
        }

        Component.onCompleted: forceActiveFocus()
        onVisibleChanged: if (visible)
            forceActiveFocus()

        ListView {
            id: strip
            anchors.fill: parent
            anchors.margins: 16
            orientation: ListView.Horizontal
            spacing: 12
            model: Wallpaper.wallpapers
            currentIndex: Wallpaper.selectedIndex
            highlightMoveDuration: 200
            onCurrentIndexChanged: strip.positionViewAtIndex(currentIndex, ListView.Contain)

            delegate: Item {
                id: thumb
                width: root.thumbWidth
                height: strip.height
                property bool isSelected: index === Wallpaper.selectedIndex
                scale: isSelected ? 1.0 : 1.0
                opacity: isSelected ? 1.0 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutSine
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutSine
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: "transparent"
                    border.width: thumb.isSelected ? 3 : 0
                    border.color: Colors.md3.primary
                    z: 1

                    Image {
                        id: previewImage
                        anchors.fill: parent
                        anchors.margins: 3
                        source: "file://" + modelData
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: false
                        sourceSize.width: 320
                        sourceSize.height: 200
                        opacity: 0        // was visible: false
                    }

                    Item {
                        id: maskShape
                        anchors.fill: previewImage
                        layer.enabled: true
                        visible: false

                        Rectangle {
                            anchors.fill: parent
                            radius: 12
                        }
                    }

                    MultiEffect {
                        anchors.fill: previewImage
                        source: previewImage
                        maskEnabled: true
                        maskSource: maskShape
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Wallpaper.selectedIndex = index;
                        Wallpaper.selectAndApply();
                        GlobalStates.wallpaperSwitcherVisible = false;
                    }
                }
            }
        }

        MouseArea {
            id: wheelOverlay
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: function (wheel) {
                if (wheel.angleDelta.y < 0)
                    Wallpaper.selectedIndex = Math.min(Wallpaper.selectedIndex + 1, Wallpaper.wallpapers.length - 1);
                else if (wheel.angleDelta.y > 0)
                    Wallpaper.selectedIndex = Math.max(Wallpaper.selectedIndex - 1, 0);
                wheel.accepted = true;
            }
        }
    }
}
