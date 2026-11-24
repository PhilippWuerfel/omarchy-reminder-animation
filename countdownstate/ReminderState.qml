pragma Singleton
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import "Focus.js" as Focus

Item {
    id: state
    property var items: []
    property double now: Math.floor(Date.now()/1000)
    property var pinned: null
    readonly property var next: Focus.display(items, pinned, now)
    readonly property bool finished: !!pinned && pinned.at <= now
    readonly property int seconds: next ? Math.max(0,next.at - now) : 0
    // Tick once per second, but only while a countdown runs.
    readonly property bool counting: Focus.counting(next, now)
    onCountingChanged: if (counting) tick.arm()
    Timer {
        id: tick
        function arm() {
            state.now = Math.floor(Date.now()/1000)
            interval = Focus.msUntilNextTick(Date.now(), 1000)
            restart()
        }
        onTriggered: {
            state.now = Math.floor(Date.now()/1000)
            if (state.counting) arm()
        }
    }
    property bool refreshPending: false
    function refresh() {
        if (query.running) refreshPending = true
        else query.running = true
    }
    // omarchy-reminder schedules each reminder as a transient systemd user
    // timer. systemd writes its unit file when the reminder is set and removes
    // it once the timer fires or is stopped, so watching that folder reacts to
    // every change within milliseconds, without polling.
    readonly property string systemdDir: "file://" + Quickshell.env("XDG_RUNTIME_DIR") + "/systemd"
    // systemd creates the transient folder with its first transient unit,
    // which can happen after the shell starts. Wait for it in the parent folder.
    property bool hasTransientDir: false
    FolderListModel {
        folder: state.systemdDir
        showFiles: false
        onStatusChanged: if (status === FolderListModel.Ready)
            state.hasTransientDir = indexOf(state.systemdDir + "/transient") >= 0
    }
    property string units: ""
    FolderListModel {
        id: unitFiles
        folder: state.hasTransientDir ? state.systemdDir + "/transient" : ""
        nameFilters: ["omarchy-reminder-*.timer"]
        showDirs: false
        showDotAndDotDot: false
        // The model reloads on any change in the folder; only refresh when the
        // set of reminder timers actually differs.
        onStatusChanged: {
            if (status !== FolderListModel.Ready) return
            let names = []
            for (let i = 0; i < count; i++) names.push(get(i, "fileName"))
            const joined = names.join("\n")
            if (joined !== state.units) {
                state.units = joined
                state.refresh()
            }
        }
    }
    Component.onCompleted: refresh()
    Process {
        id: query
        command: ["omarchy-reminder", "show", "--json"]
        // A change seen while a query runs needs one more query afterwards.
        onExited: if (state.refreshPending) {
            state.refreshPending = false
            Qt.callLater(state.refresh)
        }
        stdout: StdioCollector {
            onStreamFinished: {
                state.now = Math.floor(Date.now()/1000)
                try {
                    const updated = JSON.parse(text).reminders.sort((a,b) => a.at-b.at)
                    state.pinned = Focus.reconcile(updated, state.pinned, state.now)
                    state.items = updated
                } catch (_) { /* keep last successful snapshot */ }
            }
        }
    }
}
