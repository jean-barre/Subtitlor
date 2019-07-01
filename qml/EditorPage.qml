import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0
import "common"

Item {
    function displayLogMessage(code, time, message) {
        log_message_time.text = time
        log_message_text.text = message
        switch(code) {
        case -1:
            log_message_text.color = "red"
            break;
        case 0:
            log_message_text.color = "black"
            break;
        case 1:
            log_message_text.color = "green"
            break;
        }
    }

    property StackView stack
    property string video_url

    Rectangle {
        id: video_viewer
        height: parent.height * 0.35
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.02
        color: "black"

        MediaPlayer {
            id: player
            objectName: "media_player"
            source: video_url
            autoPlay: false
            signal setVideoDuration()
            onDurationChanged: {
                setVideoDuration()
            }
        }

        VideoOutput {
            id: video_output
            source: player
            anchors.fill: parent
        }
    }

    MediaController {
        id: video_controller
        height: parent.height * 0.1
        width: parent.width * 0.8
        media_player: player
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: video_viewer.bottom
        anchors.topMargin: parent.height * 0.02
    }

    MarkerEditor {
        id: marker_editor
        media_player: player
        height: parent.height * 0.47
        width: parent.width * 0.68
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02
    }

    RoundButton {
        height: parent.height * 0.4
        width: parent.width * 0.1
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        background_color: "black"
        button_text: "Export"

        onClicked: {
            stack.push({item: export_page, properties: {stack: stack, objectName:"Export"}})
        }
        Component{
            id: export_page
            ExportPage {}
        }
    }

    Rectangle {
        height: parent.height * 0.03
        width: parent.width
        anchors.bottom: parent.bottom
        border.color: "grey"

        Row {
            anchors.fill: parent
            anchors.margins: 2
            anchors.leftMargin: 10
            spacing: 10

            Text {
                text: "Message :"
                font.pixelSize: 8
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: log_message_time
                font.pixelSize: 8
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: log_message_text
                font.pixelSize: 8
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.4
        visible: player.status === "Loading"

        Text {
            anchors.centerIn: parent
            text: "Loading Video"
            font.pointSize: 19
        }
    }
}
