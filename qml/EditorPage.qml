import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0

Item {

    property StackView stack
    property string video_url

    Rectangle {
        id: video_viewer
        height: parent.height * 0.4
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        color: "black"

        MediaPlayer {
            id: player
            source: video_url
            autoPlay: false
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
        anchors.topMargin: parent.height * 0.01
    }

    Text {
        id: file_url
        height: parent.height * 0.15
        width: parent.width * 0.4
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.1
        text: video_url
        wrapMode: Text.WordWrap
        color: "grey"
    }

    MouseArea {
        height: parent.height * 0.15
        width: parent.width * 0.2
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.1

        Rectangle {
            color: "black"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                text: "Edit page"
                color: "white"
            }
        }

        onClicked: {
            stack.pop(stack.find(function(item) {
                return item.name === "Home";
            }))
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
