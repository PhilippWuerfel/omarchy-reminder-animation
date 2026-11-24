pragma Singleton
import QtQuick
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
    Timer { interval: 1000; running: state.items.length > 0; repeat: true; onTriggered: state.now = Math.floor(Date.now()/1000) }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: if (!query.running) query.running = true }
    Process {
        id: query
        command: ["omarchy-reminder", "show", "--json"]
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
