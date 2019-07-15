import QtQuick 2.6
import QtMultimedia 5.0

Rectangle {
    property MediaPlayer player: media_player
    property string viewer_video_url

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
    }
}
