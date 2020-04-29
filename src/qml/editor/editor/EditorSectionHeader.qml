import QtQuick 2.12
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0

Row {
    width: 600
    height: 200
    spacing: width * 0.2

    property int subtitlesNumber: 0
    property bool onSubtitle: mainController.editor.subtitles.onSubtitle

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

    MouseArea {
        id: time_input_helper_mouse_area
        width: parent.width * 0.1
        height: parent.height * 0.5
        anchors.verticalCenter: parent.verticalCenter
        enabled: mainController.editor.subtitles.temporarySavingEnabled
        visible: mainController.editor.subtitles.temporarySavingEnabled
        hoverEnabled: true

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/img/safety.png"
            mipmap: true
        }

        Rectangle {
            width: 200
            height: 70
            anchors.bottom: parent.top
            anchors.bottomMargin: Theme.margin * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            color: "black"
            radius: 5
            visible: parent.containsMouse

            Label {
                anchors.fill: parent
                text: "Modification are temporary\nsaved in " + mainController.editor.subtitles.temporaryFileURL
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: Theme.fontSmallPointSize
            }
        }
    }
}
