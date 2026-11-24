import QtQuick
Item {
    id: root
    implicitWidth: 107; implicitHeight: 20
    property color ink: "white"
    Rectangle {
        anchors.centerIn: parent; width: 10; height: 10; radius: 5; color: root.ink
        SequentialAnimation on scale { running: root.visible; loops: Animation.Infinite
            NumberAnimation { from: 0.65; to: 1.6; duration: 550; easing.type: Easing.InOutSine }
            NumberAnimation { from: 1.6; to: 0.65; duration: 550; easing.type: Easing.InOutSine }
        }
    }
}
