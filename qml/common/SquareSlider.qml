import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import "visual_markers.js" as VMarkers

Item {

    signal seek(int value);
    property int sliderValue
    property int sliderMaxValue
    property int sliderSecondPixelSize

    SliderTickmarks {
        x: root.background.x
        width: root.background.width
        height: parent.height
        secondPixelSize: sliderSecondPixelSize
    }

    function addMarker(begin, duration) {
        VMarkers.addMarker(slider_timeline, begin, duration)
    }

    function removeMarker(begin) {
        VMarkers.removeMarker(slider_timeline, begin)
    }

    Slider {
        id: root
        width: parent.width
        height: parent.height
        value: sliderValue
        to: sliderMaxValue

        onPressedChanged: {
            seek(Math.round(root.value));
        }

        background: Rectangle {
            id: slider_timeline
            property int to: root.to

            x: root.leftPadding + root.handle.width / 2
            y: root.topPadding + root.availableHeight / 2 + height / 2
            implicitWidth: 200
            implicitHeight: 8
            width: root.availableWidth - root.handle.width
            height: implicitHeight
            radius: 2
            color: "#bdbebf"
    /*
            Rectangle {
                width: root.visualPosition * parent.width
                height: parent.height
                color: "#21be2b"
                radius: 2
            }
            */
        }

        handle: Item {
            x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
            y: root.topPadding + root.availableHeight / 2 - height / 2
            implicitWidth: root.height * 0.5
            implicitHeight: root.height * 0.5

            Rectangle {
                id: stick
                anchors.centerIn: parent
                color: root.pressed ? "white" : "lightgray"
                border.color: root.pressed ? "gray" : "black"
                border.width: 4
                implicitWidth: 2
                implicitHeight: parent.height
            }

            Rectangle {
                id: square
                anchors.centerIn: parent
                anchors.verticalCenterOffset: - root.height * 0.4
                color: root.pressed ? "white" : "lightgray"
                border.color: root.pressed ? "gray" : "black"
                border.width: 4
                implicitWidth: parent.width
                implicitHeight: parent.height
                radius: 10
            }
        }
    }
}
