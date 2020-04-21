import QtQuick 2.12
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0

Row {
    width: 600
    height: 200
    spacing: width * 0.2

    property int subtitlesNumber: 0
    property bool onSubtitle: false

    Row {
        width: parent.width * 0.4
        height: parent.height
        spacing: width * 0.1

        Label {
            width: parent.width * 0.45
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Subtitles Number"
        }

        Label {
            width: parent.width * 0.45
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: subtitlesNumber
            font.styleName: "Bold"
            font.pixelSize: 18
        }
    }

    Row {
        width: parent.width * 0.4
        height: parent.height
        spacing: width * 0.1

        Label {
            width: parent.width * 0.45
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "On Subtitle"
        }

        Item {
            width: parent.width * 0.45
            height: parent.height

            Rectangle {
                width: height
                height: parent.height / 2
                radius: height / 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: onSubtitle ? Theme.successColor : Theme.errorColor
            }
        }
    }
}
