import QtQuick 2.6
import QtQuick.Controls 2.1
import "common"

Item {

    property StackView stack
    property string video_url
    property string srt_url

    function displayLogMessage(code, time, message) {
        log_bar.displayLogMessage(code, time, message)
    }

    VideoViewer {
        id: video_viewer
        height: parent.height * 0.35
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        viewer_video_url: video_url
    }

    MediaController {
        id: video_controller
        objectName: "media_controller"
        height: parent.height * 0.17
        width: parent.width
        media_player: video_viewer.player
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: video_viewer.bottom
        anchors.topMargin: parent.height * 0.02
    }

    MarkerEditor {
        id: marker_editor
        media_player: video_viewer.player
        height: parent.height * 0.4
        width: parent.width * 0.68
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.02
    }

    RoundButton {
        height: parent.height * 0.05
        width: parent.width * 0.1
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        background_color: "black"
        button_text: "Export"

        onClicked: {
            stack.push("qrc:/qml/ExportPage.qml",
                    {
                        stack: stack,
                        objectName: "Export",
                        file_url: srt_url
                    })
        }
    }

    LogBar {
        id: log_bar
        height: parent.height * 0.03
        width: parent.width
        anchors.bottom: parent.bottom
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.4
        visible: video_viewer.player.status === "Loading"

        Text {
            anchors.centerIn: parent
            text: "Loading Video"
            font.pointSize: 19
        }
    }
}
