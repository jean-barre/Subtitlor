import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import "visual_markers.js" as VMarkers

Item {
    id: root

    signal seek(int value);
    property int sliderValue
    property int sliderMaxValue
    property int sliderSecondPixelSize
    property int sliderHandleWidth: square_slider_slider.handle.width

    signal updateSubtitleBegin(int previousBegin, int newBegin)
    signal updateSubtitleEnd(int begin, int end)

    Component.onCompleted: {
        VMarkers.setSliderRoot(root)
    }

    function addMarker(start, end, begin, duration) {
        if (start === -1)
        {
            start = 0
        }
        if (end === -1)
        {
            end = sliderMaxValue
        }
        VMarkers.addMarker(slider_timeline, sliderSecondPixelSize, start, end, begin, begin + duration)
    }

    function removeMarker(begin) {
        VMarkers.removeMarker(slider_timeline, sliderSecondPixelSize, begin)
    }

    SliderTickmarks {
        x: square_slider_slider.background.x
        width: slider_timeline.width
        height: parent.height
        secondPixelSize: sliderSecondPixelSize
    }

    Slider {
        id: square_slider_slider
        width: parent.width
        height: parent.height
        value: sliderValue
        to: sliderMaxValue
        padding: 0

        onPressedChanged: {
            seek(Math.round(square_slider_slider.value));
        }

        background: Rectangle {
            id: slider_timeline
            property int to: square_slider_slider.to

            x: square_slider_slider.leftPadding + square_slider_slider.handle.width / 2
            y: square_slider_slider.topPadding + square_slider_slider.availableHeight / 2 + height / 2
            implicitWidth: 200
            implicitHeight: 8
            width: square_slider_slider.availableWidth - square_slider_slider.handle.width
            height: implicitHeight
            color: "#bdbebf"

            Rectangle {
                width: square_slider_slider.visualPosition * parent.width
                height: parent.height
                color: "black"
            }
        }

        handle: Item {
            x: square_slider_slider.leftPadding + square_slider_slider.visualPosition * (square_slider_slider.availableWidth - width) + stick.width / 2
            y: square_slider_slider.topPadding + square_slider_slider.availableHeight / 2 - height / 2
            implicitWidth: square_slider_slider.height * 0.6
            implicitHeight: square_slider_slider.height * 0.6

            Rectangle {
                id: stick
                anchors.centerIn: parent
                color: "black"
                implicitWidth: 2
                implicitHeight: parent.height
            }

            Rectangle {
                id: square
                anchors.centerIn: parent
                anchors.verticalCenterOffset: - square_slider_slider.height * 0.4
                color: "black"
                implicitWidth: parent.width * 0.7
                implicitHeight: parent.height * 0.7
                radius: width / 2
            }
        }
    }
}
