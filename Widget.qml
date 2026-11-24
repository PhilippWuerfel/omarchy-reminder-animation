import QtQuick
import QtQuick.Controls as QQC
import "countdownstate" as Local

Item {
    id: root
    property var bar
    property var settings
    readonly property string skinName: settings?.skin || "plain"
    readonly property var reminder: Local.ReminderState.next
    readonly property int seconds: Local.ReminderState.seconds
    visible: !!reminder
    implicitWidth: visible ? Math.max(107,row.width) + 8 : 0
    implicitHeight: bar ? bar.barSize : 26
    Row {
        id: row
        visible: !Local.ReminderState.finished
        anchors.centerIn: parent
        spacing: 6
        CountdownVisual {
            skin: root.skinName
            anchors.verticalCenter: parent.verticalCenter
            ink: root.bar ? root.bar.foreground : 'white'
            progress: root.reminder ? 1 - root.seconds / Math.max(1, root.reminder.minutes * 60) : 0
        }
        Text {
            text: String(Math.floor(root.seconds/60)).padStart(2,'0') + ':' + String(root.seconds%60).padStart(2,'0')
            font.family: root.bar ? root.bar.fontFamily : 'monospace'
            font.pixelSize: 12
            color: root.bar ? root.bar.foreground : 'white'
        }
    }
    CountdownVisual { anchors.centerIn: parent; skin: root.skinName; part: "Finish"; ink: root.bar ? root.bar.foreground : "white"; active: Local.ReminderState.finished; visible: active }
    QQC.Menu {
        id: picker
        popupType: QQC.Popup.Window
        y: root.height
        QQC.MenuItem { text: 'Automatic: next timer'; onTriggered: Local.ReminderState.pinned = null }
        Instantiator {
            id: choices
            model: []
            delegate: ReminderMenuItem {
                required property var modelData
                text: (Local.ReminderState.pinned?.unit === modelData.unit ? '✓ ' : '') + modelData.label + ' · ' + modelData.remaining
                onTriggered: if (modelData.at > Date.now()/1000) Local.ReminderState.pinned = modelData
            }
            onObjectAdded: (index, obj) => picker.insertItem(index+1,obj)
            onObjectRemoved: (index, obj) => picker.removeItem(obj)
        }
    }
    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onEntered: if (root.bar && root.reminder) root.bar.showTooltip(root, root.reminder.label)
        onExited: if (root.bar) root.bar.hideTooltip(root)
        onClicked: {
            if (root.bar) root.bar.hideTooltip(root)
            if (Local.ReminderState.finished) Local.ReminderState.pinned = null
            else { choices.model = Local.ReminderState.items; picker.open() }
        }
    }
    onReminderChanged: if (bar && hover.containsMouse) { if (reminder) bar.showTooltip(root, reminder.label); else bar.hideTooltip(root) }
}
