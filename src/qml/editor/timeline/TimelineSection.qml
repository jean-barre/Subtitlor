import QtQuick 2.0

Item {
    width: 1000
    height: 300

    property int secondPixelSize: 200

    Item {
        height: parent.height
        width: parent.width

        SSlider {
            id: timeline_section_slider
            height: parent.height
            width: mainController.editor.video.mediaObject.sduration / 1000 * secondPixelSize + sliderHandleWidth
            sliderSecondPixelSize: secondPixelSize
        }
    }

    SideSliderArea {
        width: parent.width * 0.1
        height: parent.height
        slider: timeline_section_slider
        isDecrease: true
        parentWidth: parent.width
    }

    SideSliderArea {
        width: parent.width * 0.1
        height: parent.height
        anchors.right: parent.right
        slider: timeline_section_slider
        parentWidth: parent.width
    }
}
