import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import com.subtitlor.theme 1.0
import com.subtitlor.editor 1.0

Item {

    property int sliderSecondPixelSize
    property int sliderHandleWidth: sslider_slider.handle.width

    SliderTickmarks {
        x: sslider_slider.background.x
        width: sslider_slider_background.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        secondPixelSize: sliderSecondPixelSize
    }

    Rectangle {
        x: sslider_slider_background.x
        width: sslider_slider_background.width
        height: 2
        anchors.bottom: parent.bottom
        color: Theme.foregroundColor
        opacity: 0.12
    }

    Slider {
        id: sslider_slider
        width: parent.width
        height: parent.height * 0.5
        padding: 0
        value: mainController.editor.video.mediaObject.position
        to: mainController.editor.video.mediaObject.duration

        onPressedChanged: {
            mainController.editor.video.mediaObject.setPosition(value)
            mainController.editor.video.mediaObject.pause()
        }

        background: Item {
            id: sslider_slider_background
            property int to: sslider_slider.to

            x: sslider_slider.leftPadding + sslider_slider.handle.width / 2
            y: sslider_slider.topPadding + sslider_slider.availableHeight / 2 + height / 2
            implicitWidth: 200
            implicitHeight: 8
            width: sslider_slider.availableWidth - sslider_slider.handle.width
            height: implicitHeight

            Rectangle {
                anchors.fill: parent
                color: Theme.foregroundColor
            }

            Rectangle {
                width: sslider_slider.visualPosition * parent.width
                height: parent.height
                color: Theme.accentColor
                opacity: 1
            }
        }

        handle: Item {
            x: sslider_slider.leftPadding + sslider_slider.visualPosition * (sslider_slider.availableWidth - width) + sslider_slider_handle_stick.width / 2
            y: sslider_slider.topPadding + sslider_slider.availableHeight / 2 - height / 2
            implicitWidth: sslider_slider.height
            implicitHeight: sslider_slider.height

            Rectangle {
                id: sslider_slider_handle_stick
                implicitWidth: 2
                implicitHeight: parent.height
                anchors.centerIn: parent
                color: Theme.accentColor
            }

            Rectangle {
                implicitWidth: parent.width * 0.5
                implicitHeight: parent.height * 0.5
                anchors.centerIn: parent
                anchors.verticalCenterOffset: - (sslider_slider_handle_stick.height) * 0.5
                color: Theme.accentColor
                radius: width * 0.5
            }
        }
    }
}
