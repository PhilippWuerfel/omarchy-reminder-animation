import QtQuick
Item {
    implicitWidth: 68; implicitHeight: 14
    property real progress: 0
    property color ink: "white"
    Rectangle { anchors.centerIn: parent; width: parent.width; height: 4; radius: 2; color: Qt.alpha(parent.ink,0.24)
        Rectangle { width: parent.width*(1-Math.min(1,Math.max(0,progress))); height: parent.height; radius: 2; color: ink }
    }
}
