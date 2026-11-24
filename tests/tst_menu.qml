import QtQuick
import QtTest

TestCase {
    name: "ReminderMenu"
    function test_literalLabel() {
        const source = Qt.createComponent(Qt.resolvedUrl('../ReminderMenuItem.qml'))
        compare(source.status, Component.Ready, source.errorString())
        const label = '<b>Tea & coffee</b>'
        const item = createTemporaryObject(source, this, {text: label})
        verify(item !== null)
        compare(item.contentItem.textFormat, Text.PlainText)
        compare(item.contentItem.text, label)
    }
}
