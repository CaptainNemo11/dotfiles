import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: container
    width: 640
    height: 480
    property color colorBg: "#000000"
    property color colorFg: "#ffffff"
    property color colorDim: "#707070"
    property color colorBoxBg: "#ffffff"
    property color colorBorder: "#707070"
    property color colorActiveBorder: "#707070"
    property color colorPlaceholder: "#707070"

    property bool showDefaultLayout: true

    color: config.backgroundColor

    
    Image {
        id: bgImage
        anchors.fill: parent
        source: config.background || ""
        fillMode: Image.PreserveAspectCrop
        visible: source != ""
    }

    // idle timeout
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onPositionChanged: { idleTimer.restart(); container.showDefaultLayout = true; }
        onPressed: { idleTimer.restart(); container.showDefaultLayout = true; }
    }

    Timer {
        id: idleTimer
        interval: 120000 // 2 min
        running: true
        repeat: false
        onTriggered: { container.showDefaultLayout = false; }
    }

    Item {
        focus: true
        Keys.onPressed: {
            idleTimer.restart();
            container.showDefaultLayout = true;
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 25
        width: 300

        Text {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            color: colorFg
            font.pointSize: 48
            font.bold: true
            text: Qt.formatDateTime(new Date(), "hh:mm AP")

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm AP")
            }
        }

        Column {
            width: parent.width
            spacing: 20
            visible: container.showDefaultLayout
            opacity: container.showDefaultLayout ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 250 } }

            ComboBox {
                id: userSelector
                width: parent.width
                model: userModel
                textRole: "name"
                currentIndex: userModel.lastIndex

                contentItem: Text {
                    leftPadding: 12
                    rightPadding: 12
                    text: userSelector.currentText
                    color: "#000000"
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitHeight: 40
                    color: colorBoxBg
                    border.color: userSelector.activeFocus ? colorActiveBorder : colorBorder
                    border.width: 1
                    radius: 8
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                popup: Popup {
                    y: userSelector.height + 4
                    width: userSelector.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 0
                    
                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: userSelector.popup.visible ? userSelector.delegateModel : null
                    }
                    background: Rectangle {
                        color: colorBoxBg
                        border.color: colorBorder
                        radius: 8
                    }
                }
            }

            TextField {
                id: passwordInput
                width: parent.width
                placeholderText: "Enter Password"
                placeholderTextColor: colorPlaceholder
                color: "#000000"
                echoMode: TextInput.Password
                focus: container.showDefaultLayout
                leftPadding: 12
                rightPadding: 12
                font.pointSize: 12

                onAccepted: {
                    sddm.login(userSelector.currentText, passwordInput.text, sessionSelector.currentIndex)
                }

                background: Rectangle {
                    implicitHeight: 40
                    color: colorBoxBg
                    border.color: passwordInput.activeFocus ? colorActiveBorder : colorBorder
                    border.width: 1
                    radius: 8
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                }
            }
        }
    }

    ComboBox {
        id: sessionSelector
        width: 200
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 25
        model: sessionModel
        textRole: "name"
        currentIndex: sessionModel.lastIndex
        
        visible: container.showDefaultLayout
        opacity: container.showDefaultLayout ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 250 } }
        contentItem: Text {
            text: sessionSelector.currentText
            color: sessionSelector.hovered ? colorFg : colorDim
            font.pointSize: 11
            verticalAlignment: Text.AlignVCenter
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        background: Rectangle { color: "transparent" }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 25
        spacing: 15

        Button {
            id: rebootBtn
            visible: sddm.canReboot
            onClicked: sddm.reboot()
            hoverEnabled: true
            
            contentItem: Text {
                text: "󰑙"
                color: rebootBtn.hovered ? colorFg : colorDim
                font.pointSize: 11
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            background: Rectangle { color: "transparent" }

            ToolTip.visible: hovered
            ToolTip.delay: 400
            ToolTip.text: "Reboot"
        }

        Button {
            id: shutdownBtn
            visible: sddm.canPowerOff
            onClicked: sddm.powerOff()
            hoverEnabled: true
            
            contentItem: Text {
                text: "󰐥"
                color: shutdownBtn.hovered ? colorFg : colorDim 
                font.pointSize: 11
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            background: Rectangle { color: "transparent" }

            ToolTip.visible: hovered
            ToolTip.delay: 400
            ToolTip.text: "Shutdown"
        }

        Button {
            id: suspendBtn
            visible: sddm.canSuspend
            onClicked: sddm.suspend()
            hoverEnabled: true
            
            contentItem: Text {
                text: "󰤄"
                color: suspendBtn.hovered ? colorFg : colorDim
                font.pointSize: 11
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            background: Rectangle { color: "transparent" }

            ToolTip.visible: hovered
            ToolTip.delay: 400
            ToolTip.text: "Suspend"
        }
    }

    Text {
        id: batteryDisplay
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 25
        color: colorDim
        font.pointSize: 14
        text: "󰁹 --%"

        Timer {
            id: batteryTimer
            interval: 10000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var requestCap = new XMLHttpRequest();
                requestCap.open("GET", "file:///sys/class/power_supply/BAT0/capacity", false);
                requestCap.send(null);
                var cap = requestCap.responseText.trim();

                var requestStatus = new XMLHttpRequest();
                requestStatus.open("GET", "file:///sys/class/power_supply/BAT0/status", false);
                requestStatus.send(null);
                var status = requestStatus.responseText.trim();

                var icon = (status === "Charging") ? "󰂄 " : "󰁹 ";
                batteryDisplay.text = icon + cap + "%";
            }
        }
    }
}
