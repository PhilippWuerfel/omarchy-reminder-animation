import QtQuick
Loader {
    id: visual
    property string skin: "plain"
    property string part: "Track"
    property real progress: 0
    property color ink: "white"
    property string failed: ""
    readonly property string requested: /^[a-z0-9_-]+$/.test(skin) ? skin : "plain"
    source: Qt.resolvedUrl("skins/" + (failed === requested + part ? "plain" : requested) + "/" + part + ".qml")
    onStatusChanged: if (status === Loader.Error && requested !== "plain") failed = requested + part
    onLoaded: {
        if ('ink' in item) item.ink = Qt.binding(() => visual.ink)
        if ('progress' in item) item.progress = Qt.binding(() => visual.progress)
    }
}
