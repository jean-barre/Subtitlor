import QtQuick 2.0
import "time_format.js" as TimeFormat

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

            Rectangle {
                width: secondPixelSize / 10
                height: parent.height * 0.5
                anchors.bottom: parent.bottom

                Text {
                    anchors.horizontalCenter: tick.horizontalCenter
                    anchors.bottom: tick.top
                    text: TimeFormat.format(index * 100)
                    visible: !(index % 10)
                    color: "grey"
                }

                Rectangle {
                    id: tick
                    width: index % 10 ? 1 : 2
                    height: index % 10 ? parent.height / 2 : parent.height
                    anchors.bottom: parent.bottom
                    border.width: 1
                    anchors.left: parent.left
                    border.color: "grey"
                }
            }
        }
    }
}
