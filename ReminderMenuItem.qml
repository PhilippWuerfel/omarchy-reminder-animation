import QtQuick
import QtQuick.Controls as QQC

QQC.MenuItem {
    id: entry
    contentItem: Text {
        text: entry.text
        textFormat: Text.PlainText
        font: entry.font
        color: entry.highlighted ? entry.palette.highlightedText : entry.palette.text
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
