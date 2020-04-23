import QtQuick 2.12
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0

Item {
    width: 600
    height: 400

    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: 0.08
    }

    Column {
        anchors.fill: parent
        spacing: height * 0.05

        Row {
            height: parent.height * 0.3
            width: parent.width * 0.6
            spacing: width * 0.2
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                height: parent.height
                width: parent.width * 0.4
                spacing: width * 0.05

                Label {
                    width: parent.width * 0.3
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "Begin time"
                }

                TimeInput {
                    id: editor_input_begin_time_input
                    width: parent.width * 0.65
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    defaultText:  mainController.editor.video.mediaObject.format(0)
                }
            }

            Row {
                height: parent.height
                width: parent.width * 0.4
                spacing: width * 0.05

                Label {
                    width: parent.width * 0.3
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "Duration"
                }

                TimeInput {
                    id: editor_input_duration_time_input
                    width: parent.width * 0.65
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    defaultText: mainController.editor.video.mediaObject.format(1000)
                }
            }
        }

        STextInput {
            width: parent.width - 2 * Theme.margin
            height: parent.height * 0.65
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Connections {
        target: mainController.editor.video.mediaObject
        onTimeFormatChanged: {
            editor_input_begin_time_input.defaultText = mainController.editor.video.mediaObject.format(0)
            editor_input_duration_time_input.defaultText = mainController.editor.video.mediaObject.format(1000)
        }
    }
}
