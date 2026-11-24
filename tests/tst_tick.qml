import QtQuick
import QtTest
import "../countdownstate/Focus.js" as Focus

TestCase {
    name: "Tick"

    function test_waits_until_next_second() {
        compare(Focus.msUntilNextTick(41730, 1000), 270)
        compare(Focus.msUntilNextTick(42999, 1000), 1)
    }
    function test_on_boundary_waits_full_step() {
        compare(Focus.msUntilNextTick(42000, 1000), 1000)
    }
    function test_always_within_one_step() {
        for (const ms of [0, 1, 499, 500, 999, 1000, 1001, 1732456789123]) {
            const wait = Focus.msUntilNextTick(ms, 1000)
            verify(wait >= 1 && wait <= 1000, ms + ' -> ' + wait)
            compare((ms + wait) % 1000, 0)
        }
    }
}
