import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0
import "common"
import "common/time_format.js" as TimeFormat

Rectangle {
    height: 100
    width: 500
    anchors.margins: 2

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

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                radius: Math.min(width, height) * 0.2

                Image {
                    source: "qrc:///img/previous.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                }
            }


            onClicked: {
                media_player.seek(media_player.position - 5000)
            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                radius: Math.min(width, height) * 0.2

                Image {
                    id: play_pause_image
                    source: "qrc:///img/play.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                }
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

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                radius: Math.min(width, height) * 0.2

                Image {
                    source: "qrc:///img/next.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                }
            }


            onClicked: {
                media_player.seek(media_player.position + 5000)
            }
        }
    }

    Row {
        spacing: parent.width * 0.03
        height: parent.height * 0.4
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        SquareSlider {
            id: slider
            value: media_player.position
            height: parent.height
            width: parent.width * 0.7
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

        Row {
            height: parent.height
            width: parent.width * 0.2
            spacing: parent.width * 0.01

            Text {
                height: parent.height
                width: media_player.position > 360000 ? 84 : (media_player.position > 60000 ? 64 : 44)
                text: TimeFormat.format(media_player.position)
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }

            Text {
                height: parent.height
                text: "/"
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                height: parent.height
                width: media_player.position > 360000 ? 84 : (media_player.position > 60000 ? 64 : 44)
                text: TimeFormat.format(media_player.duration)
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
