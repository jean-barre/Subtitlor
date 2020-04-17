import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12
import com.subtitlor.theme 1.0

import "../../common"
import "../../common/time_format.js" as TimeFormat

Item {
    height: 100
    width: 500

    property var mediaPlayer : mainController.editor.video.mediaObject

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
                mediaPlayer.setPosition(mediaPlayer.position - 5000)
            }
        }

        SButton {
            height: parent.height
            width: parent.width * 0.2

            iconSource: mediaPlayer ? ((mediaPlayer.state === MediaPlayer.PlayingState) ?
                            "qrc:/img/pause.png" : "qrc:/img/play.png") : ""
            onClicked: {
                if (mediaPlayer.state === MediaPlayer.PlayingState) {
                    mediaPlayer.pause()
                } else {
                    mediaPlayer.play()
                }
            }
        }

        SButton {
            height: parent.height
            width: parent.width * 0.2

            iconSource: "qrc:/img/forward.png"
            onClicked: {
                mediaPlayer.setPosition(mediaPlayer.position + 5000)
            }
        }
    }

    Row {
        height: parent.height
        width: parent.width * 0.2
        anchors.right: parent.right
        anchors.rightMargin: Theme.margin
        spacing: width * 0.05

        Label {
            height: parent.height
            width: parent.width * 0.4
            text: mediaPlayer ? TimeFormat.format(mediaPlayer.position) : ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            height: parent.height
            text: "/"
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            height: parent.height
            width: parent.width * 0.4
            text: mediaPlayer ? TimeFormat.format(mediaPlayer.duration) : ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
