import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import com.subtitlor.theme 1.0

import "../../common"
import "../../common/time_format.js" as TimeFormat

Item {
    height: 100
    width: 500


    Row {
        height: parent.height
        width: parent.width * 0.3
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: width * 0.2

        SButton {
            height: parent.height
            width: parent.width * 0.2

            iconSource: "qrc:/img/backward.png"
            onClicked: {
                media_player.seek(media_player.position - 5000)
            }
        }

        SButton {
            height: parent.height
            width: parent.width * 0.2

            iconSource: "qrc:/img/play.png"
            onClicked: {
                if (playing) {
                    playing = false
                    media_player.pause()
                    iconSource = "qrc:/img/play.png"
                } else {
                    playing = true
                    media_player.play()
                    iconSource = "qrc:/img/pause.png"
                }
            }
        }

        SButton {
            height: parent.height
            width: parent.width * 0.2

            iconSource: "qrc:/img/forward.png"
            onClicked: {
            }
        }
    }

    Row {
        height: parent.height
        width: parent.width * 0.2
        anchors.right: parent.right
        anchors.rightMargin: Theme.margin
        spacing: parent.width * 0.01

        Label {
            height: parent.height
            width: media_player.position > 360000 ? 84 : (media_player.position > 60000 ? 64 : 44)
            text: TimeFormat.format(media_player.position)
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            height: parent.height
            text: "/"
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            height: parent.height
            width: media_player.position > 360000 ? 84 : (media_player.position > 60000 ? 64 : 44)
            text: TimeFormat.format(media_player.duration)
            verticalAlignment: Text.AlignVCenter
        }
    }
}
