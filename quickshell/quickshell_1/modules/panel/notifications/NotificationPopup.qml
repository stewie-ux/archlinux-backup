import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.service
import qs.modules.common
import qs.modules.common.widgets

PanelWindow {
    id: root

    readonly property int toastWidth: 340
    readonly property int margin: 12

    visible: NotificationService.popups.length > 0

    anchors {
        top: true
        right: true
    }

    margins {
        top: root.margin
        right: root.margin
    }

    implicitWidth: root.toastWidth
    implicitHeight: Math.min(list.contentHeight, 700)

    exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:notifications"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    color: "transparent"

    ListView {
        id: list
        anchors.fill: parent
        spacing: 8
        model: NotificationService.popups
        interactive: false
        clip: true

        add: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 150
            }
            NumberAnimation {
                property: "x"
                from: root.toastWidth
                to: 0
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
        remove: Transition {
            NumberAnimation {
                property: "opacity"
                to: 0
                duration: 120
            }
            NumberAnimation {
                property: "x"
                to: root.toastWidth
                duration: 150
                easing.type: Easing.InCubic
            }
        }
        displaced: Transition {
            NumberAnimation {
                property: "y"
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        delegate: Item {
            id: toastDelegate
            required property Notification modelData

            width: list.width
            height: card.implicitHeight

            readonly property color urgencyColor: {
                if (toastDelegate.modelData.urgency === NotificationUrgency.Critical)
                    return "#ff6b6b";
                if (toastDelegate.modelData.urgency === NotificationUrgency.Low)
                    return Qt.rgba(1, 1, 1, 0.4);
                return "#5c8bf5";
            }

            ColumnLayout {
                id: card
                width: parent.width
                spacing: 6

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: contentCol.implicitHeight + 20
                    radius: 14
                    color: Qt.alpha(Colors.md3.background, 0.95)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.08)

                    Rectangle {
                        width: 3
                        radius: 2
                        color: toastDelegate.urgencyColor
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: 8
                        }
                    }

                    ColumnLayout {
                        id: contentCol
                        anchors.fill: parent
                        anchors.margins: 10
                        anchors.leftMargin: 16
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            IconImage {
                                visible: toastDelegate.modelData.appIcon.length > 0
                                implicitWidth: 18
                                implicitHeight: 18
                                source: toastDelegate.modelData.appIcon
                            }

                            Text {
                                text: toastDelegate.modelData.appName
                                color: Qt.rgba(1, 1, 1, 0.6)
                                font.pixelSize: 11
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            MaterialSymbol {
                                iconSize: 14
                                color: Qt.rgba(1, 1, 1, 0.5)
                                text: "close"

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -6
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: NotificationService.dismiss(toastDelegate.modelData)
                                }
                            }
                        }

                        Text {
                            visible: toastDelegate.modelData.summary.length > 0
                            text: toastDelegate.modelData.summary
                            color: "white"
                            font.pixelSize: 13
                            font.bold: true
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }

                        Text {
                            visible: toastDelegate.modelData.body.length > 0
                            text: toastDelegate.modelData.body
                            textFormat: Text.PlainText
                            color: Qt.rgba(1, 1, 1, 0.75)
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 4
                            elide: Text.ElideRight
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 2
                            spacing: 6
                            visible: toastDelegate.modelData.actions.length > 0

                            Repeater {
                                model: toastDelegate.modelData.actions

                                delegate: Rectangle {
                                    id: actionBtn
                                    required property var modelData

                                    implicitWidth: actionLabel.implicitWidth + 20
                                    implicitHeight: 26
                                    radius: 8
                                    color: actionHover.containsMouse ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(1, 1, 1, 0.06)

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }

                                    Text {
                                        id: actionLabel
                                        anchors.centerIn: parent
                                        text: actionBtn.modelData.text
                                        color: "white"
                                        font.pixelSize: 11
                                    }

                                    MouseArea {
                                        id: actionHover
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: NotificationService.invokeAction(toastDelegate.modelData, actionBtn.modelData.identifier)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
