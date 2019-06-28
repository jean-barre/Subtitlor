import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0

Rectangle {
    height: 100
    width: 500

    property MediaPlayer media_player
    property bool playing: false

    Row {
        spacing: parent.width * 0.1
        height: parent.height * 0.4
        width: parent.width * 0.3
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Image {
                source: "qrc:///img/previous.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                media_player.seek(media_player.position - 5000)
            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Image {
                id: play_pause_image
                source: "qrc:///img/play.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                if (playing) {
                    playing = false
                    media_player.pause()
                    play_pause_image.source = "qrc:///img/play.png"
                } else {
                    playing = true
                    media_player.play()
                    play_pause_image.source = "qrc:///img/pause.png"
                }

            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Image {
                source: "qrc:///img/next.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                media_player.seek(media_player.position + 5000)
            }
        }
    }

    Slider {
        id: slider
        value: 0
        height: parent.height * 0.5
        width: parent.width
        anchors.bottom: parent.bottom
        maximumValue: media_player.duration

        onPressedChanged: {
            if (!pressed) {
                playing = false;
                media_player.seek(slider.value)
                media_player.pause()
                play_pause_image.source = "qrc:///img/play.png"
            }
        }
    }

    Connections {
        target: media_player
        onPositionChanged: {
            slider.value = media_player.position
        }
    }

}
