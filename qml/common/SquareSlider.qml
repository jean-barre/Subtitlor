import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4

Slider {
    id: root

    style: SliderStyle {

        groove: Rectangle {
            implicitWidth: root.width
            implicitHeight: root.height * 0.1
            color: "gray"
            radius: 8
        }

        handle: Rectangle {
            anchors.centerIn: parent
            color: control.pressed ? "white" : "lightgray"
            border.color: "gray"
            border.width: 2
            implicitWidth: root.height * 0.5
            implicitHeight: root.height * 0.5
            radius: 3
        }
    }
}
