// Standalone skin preview for development. Not loaded by omarchy-shell:
// only manifest.json entry points are. Run from the checkout root:
//   qml6 tools/preview.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel

ApplicationWindow {
    id: win
    width: 520; height: 380
    visible: true
    title: "Reminder Animation – skin preview"
    color: dark.checked ? "#1e1e2e" : "#eeeeee"

    readonly property url skinsDir: Qt.resolvedUrl("../skins/")
    readonly property color ink: dark.checked ? "white" : "#222222"
    property real progress: 0

    function bind(item) {
        if ('ink' in item) item.ink = Qt.binding(() => win.ink)
        if ('progress' in item) item.progress = Qt.binding(() => win.progress)
    }

    NumberAnimation on progress {
        from: 0; to: 1; duration: 8000
        loops: Animation.Infinite
        running: play.checked
    }

    FolderListModel {
        id: skins
        folder: win.skinsDir
        showFiles: false
        showDirs: true
        sortField: FolderListModel.Name
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        RowLayout {
            Label { text: "Skin:"; color: win.ink }
            ComboBox { id: skin; model: skins; textRole: "fileName" }
            CheckBox { id: dark; text: "Dark bar"; checked: true }
            CheckBox { id: play; text: "Autoplay"; checked: true }
        }

        Label { text: "Track.qml – progress " + win.progress.toFixed(2); color: win.ink }
        Loader {
            Layout.preferredWidth: 68 * zoom.value
            Layout.preferredHeight: 14 * zoom.value
            scale: zoom.value
            transformOrigin: Item.TopLeft
            source: skin.currentText ? win.skinsDir + skin.currentText + "/Track.qml" : ""
            onLoaded: win.bind(item)
        }
        Slider {
            Layout.fillWidth: true
            from: 0; to: 1
            value: win.progress
            onMoved: { play.checked = false; win.progress = value }
        }

        Label { text: "Finish.qml – loops after expiry"; color: win.ink }
        Loader {
            Layout.preferredWidth: 107 * zoom.value
            Layout.preferredHeight: 20 * zoom.value
            scale: zoom.value
            transformOrigin: Item.TopLeft
            source: skin.currentText ? win.skinsDir + skin.currentText + "/Finish.qml" : ""
            onLoaded: win.bind(item)
        }

        RowLayout {
            Label { text: "Zoom"; color: win.ink }
            Slider { id: zoom; from: 1; to: 4; value: 3; Layout.fillWidth: true }
        }
        Item { Layout.fillHeight: true }
    }
}
