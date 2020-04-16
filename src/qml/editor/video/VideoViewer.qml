import QtQuick 2.12
import QtMultimedia 5.12
import com.subtitlor.theme 1.0
import com.subtitlor.editor 1.0

import "../../common"

Rectangle {
    id: root

    height: 900
    width: 1600
    color: "black"

    VideoOutput {
        id: video_viewer_video_output
        source: mainController.editor.video
        anchors.fill: parent

        onContentRectChanged: {
            video_viewer_subtitle_area.width = video_viewer_video_output.contentRect.width
            video_viewer_subtitle_area.height = video_viewer_video_output.contentRect.height
        }
    }

    Rectangle {
        id: video_viewer_subtitle_area
        height: parent.height
        width: parent.width
        anchors.centerIn: parent
        color: "transparent"

        Text {
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

    SButton {
        height: parent.height * 0.15
        width: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: Theme.margin

        iconSource: "qrc:/img/flip.png"
        onClicked: {
            video_viewer_video_output.orientation += 90
        }
    }
}
