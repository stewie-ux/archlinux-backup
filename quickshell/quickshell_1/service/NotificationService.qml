pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property int defaultTimeout: 7000

    property list<Notification> popups: []

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        bodyHyperlinksSupported: true
        imageSupported: true
        keepOnReload: false

        onNotification: notification => {
            console.log("[Notification] received:", notification.appName, notification.summary);
            notification.tracked = true;

            root.popups = [...root.popups, notification];

            const timeout = notification.expireTimeout > 0 ? notification.expireTimeout : root.defaultTimeout;
            const timer = timerComponent.createObject(root, {
                targetNotification: notification,
                interval: timeout
            });
            timer.start();

            notification.closed.connect(() => root.removePopup(notification));
        }
    }

    Component {
        id: timerComponent
        Timer {
            id: timerObj
            required property Notification targetNotification
            repeat: false
            onTriggered: {
                root.dismiss(timerObj.targetNotification);
                timerObj.destroy();
            }
        }
    }

    function removePopup(notification) {
        root.popups = root.popups.filter(n => n !== notification);
    }

    function dismiss(notification) {
        if (notification)
            notification.dismiss();
        // removePopup also runs via the closed signal above, but this
        // covers cases where dismiss() doesn't emit closed for some senders
        root.removePopup(notification);
    }

    function invokeAction(notification, actionId) {
        const action = notification.actions.find(a => a.identifier === actionId);
        if (action)
            action.invoke();
        if (!notification.resident)
            root.dismiss(notification);
    }
}
