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

    // Units as omarchy-reminder names them: omarchy-reminder-<minutes>m-<set_at>
    readonly property var first: ({unit: 'omarchy-reminder-1m-1000', minutes: 1, at: 1060})

    function test_new_reminder_after_expiry_replaces_animation() {
        const next = {unit: 'omarchy-reminder-1m-1072', minutes: 1, at: 1132}
        compare(Focus.reconcile([next], first, 1075), next)
    }
    function test_reminder_set_before_expiry_keeps_animation() {
        const early = {unit: 'omarchy-reminder-2m-1056', minutes: 2, at: 1176}
        compare(Focus.reconcile([early], first, 1060), first)
    }
    function test_parallel_reminder_keeps_watch() {
        const parallel = {unit: 'omarchy-reminder-1m-1010', minutes: 1, at: 1070}
        compare(Focus.reconcile([first, parallel], first, 1020), first)
    }
    function test_latest_reminder_after_expiry_wins() {
        const parallel = {unit: 'omarchy-reminder-3m-1010', minutes: 3, at: 1190}
        const older = {unit: 'omarchy-reminder-5m-1070', minutes: 5, at: 1370}
        const newer = {unit: 'omarchy-reminder-9m-1072', minutes: 9, at: 1612}
        compare(Focus.reconcile([parallel, older, newer], first, 1075), newer)
    }
    function test_first_set_wins_within_one_poll() {
        const a = {unit: 'omarchy-reminder-2m-1001', minutes: 2, at: 1121}
        const b = {unit: 'omarchy-reminder-1m-1003', minutes: 1, at: 1063}
        compare(Focus.reconcile([b, a], null, 1005), a)
    }
    function test_first_set_wins_after_acknowledgement() {
        const b = {unit: 'omarchy-reminder-3m-1010', minutes: 3, at: 1190}
        const c = {unit: 'omarchy-reminder-2m-1020', minutes: 2, at: 1140}
        compare(Focus.reconcile([c, b], null, 1070), b)
    }
    function test_same_second_prefers_earlier_due() {
        const longer = {unit: 'omarchy-reminder-5m-1000', minutes: 5, at: 1300}
        const shorter = {unit: 'omarchy-reminder-1m-1000', minutes: 1, at: 1060}
        compare(Focus.reconcile([longer, shorter], null, 1001), shorter)
    }
}
