import QtQuick
import QtTest
import "../countdownstate/Focus.js" as Focus

TestCase {
    name: "SingleReminder"
    readonly property var timer: ({unit: 'one', at: 100})

    function test_no_selection_required() {
        let watched = Focus.reconcile([timer], null, 60)
        compare(watched, timer)
        watched = Focus.reconcile([], watched, 100)
        compare(Focus.display([], watched, 110), timer)
        compare(Focus.reconcile([], watched, 120), timer)
        // Acknowledgement clears the watch. A stale snapshot must not rearm it.
        compare(Focus.reconcile([timer], null, 120), null)
        compare(Focus.reconcile([], null, 130), null)
    }
    function test_cancel_before_due() {
        compare(Focus.reconcile([], timer, 80), null)
    }
    function test_no_implicit_multi_timer_policy() {
        compare(Focus.reconcile([timer, {unit: 'two', at: 200}], null, 60), null)
    }
}
