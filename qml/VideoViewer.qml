import QtQuick 2.6
import QtMultimedia 5.2

Rectangle {
    id: root
    objectName: "video_viewer"
    property MediaPlayer player: media_player
    property string viewer_video_url

    function setVisualSubtitle(text) {
        subtitle.text = text
    }

    height: 900
    width: 1600
    color: "black"

    MediaPlayer {
        id: media_player
        objectName: "media_player"
        autoPlay: false
        source: video_url
        signal setVideoDuration()
        onDurationChanged: {
            setVideoDuration()
        }
    }

    VideoOutput {
        id: video_output
        source: player
        anchors.fill: parent
        onContentRectChanged: {
            subtitle_rectangle.width = video_output.contentRect.width
            subtitle_rectangle.height = video_output.contentRect.height
        }
    }

    Rectangle {
        id: subtitle_rectangle
        height: parent.height
        width: parent.width
        anchors.centerIn: parent
        color: "transparent"

        Text {
            id: subtitle
            width: parent.width * 0.8
            height: parent.height * 0.3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.family: "DejaVu Sans"
            fontSizeMode: Text.Fit
            font.pixelSize: height / 4
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            style: Text.Outline
            styleColor: "black"
            wrapMode: Text.Wrap
        }
    }

    MouseArea {
        id: flip_button
        height: parent.height * 0.15
        width: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:///img/flip.png"
        }

        onClicked: {
            video_output.orientation += 90
        }
    }
}
