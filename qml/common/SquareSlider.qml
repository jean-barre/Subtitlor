import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import "visual_markers.js" as VMarkers

Slider {
    id: root

    function addMarker(begin, duration) {
        VMarkers.addMarker(root, begin, duration)
    }

    function removeMarker(begin) {
        VMarkers.removeMarker(root, begin)
    }

    style: SliderStyle {

        groove: Rectangle {
            implicitWidth: root.width
            implicitHeight: root.height * 0.1
            color: "gray"
            radius: 8
        }

        handle: Item {
            anchors.centerIn: parent
            implicitWidth: root.height * 0.5
            implicitHeight: root.height * 0.5

            Rectangle {
                id: stick
                anchors.centerIn: parent
                color: control.pressed ? "white" : "lightgray"
                border.color: control.pressed ? "gray" : "black"
                border.width: 2
                implicitWidth: 1
                implicitHeight: parent.height
                radius: 3
            }

            Rectangle {
                id: square
                anchors.centerIn: parent
                anchors.verticalCenterOffset: - root.height * 0.4
                color: control.pressed ? "white" : "lightgray"
                border.color: control.pressed ? "gray" : "black"
                border.width: 2
                implicitWidth: parent.width
                implicitHeight: parent.height
                radius: 3
            }
        }
    }
}
