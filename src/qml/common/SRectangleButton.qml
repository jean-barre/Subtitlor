import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import com.subtitlor.theme 1.0

SButton {
    id: sbutton_root
    width: 300
    height: 100

    Rectangle {
        anchors.fill: parent
        color: sbutton_root.pressed ? Theme.accentColor : "transparent"
        border.color: Theme.accentColor
        border.width: 2
    }
}
