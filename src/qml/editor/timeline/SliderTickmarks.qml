import QtQuick 2.12
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0
import "../../common/time_format.js" as TimeFormat

Item {
    id: root
    width: 1200
    height: 600

    property int secondPixelSize

    Row {
        anchors.fill: parent
        spacing: 0

        Repeater {
            model: parent.width / secondPixelSize * 10

            Item {
                width: secondPixelSize / 10
                height: parent.height

                Label {
                    anchors.horizontalCenter: slider_tickmarks_tick.horizontalCenter
                    anchors.top: parent.top
                    text: mainController.editor.video.mediaObject.format(index * 100)
                    visible: !(index % 10)
                    color: Theme.foregroundColor
                    opacity: 0.12
                }

                Rectangle {
                    id: slider_tickmarks_tick
                    width: index % 10 ? 1 : 2
                    height: index % 10 ? parent.height * 0.2 : parent.height * 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Theme.margin * 0.5
                    border.width: 1
                    anchors.left: parent.left
                    border.color: Theme.foregroundColor
                    opacity: 0.12
                }
            }
        }
    }
}
