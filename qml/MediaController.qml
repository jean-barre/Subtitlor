import QtQuick 2.6
import QtQuick.Controls 2.1
import QtMultimedia 5.0
import "common"
import "common/time_format.js" as TimeFormat

Rectangle {
    height: 100
    width: 500
    anchors.margins: 0
    color: "white"

    property MediaPlayer media_player
    property bool playing: false
    property int secondPixelSize: 120

    // signal emitted when the subtitle RangeSlider is manipulated
    // 	previousBegin is the begin value before the manipulation.
    // 	newBegin is the begin value after the manipulation.
    // 	end is the end value after le manipulation.
    // 	0 if manipulating the first handle of the RangeSlider.
    signal editSubtitleTiming(int previousBegin, int newBegin, int end)

    function setVideoDuration(duration) {
        slider.sliderMaxValue = duration
    }

    function addMarker(min, max, begin, end) {
        slider.addMarker(min, max, begin, end)
    }

    function editMarker(min, max, previousBegin, begin, end) {
        slider.editMarker(min, max, previousBegin, begin, end)
    }

    function editMarkerMin(begin, min) {
        slider.editMarkerMin(begin, min)
    }

    function editMarkerMax(begin, max) {
        slider.editMarkerMax(begin, max)
    }

    function removeMarker(begin) {
        slider.removeMarker(begin)
    }

    Row {
        spacing: parent.width * 0.1
        height: parent.height * 0.3
        width: parent.width * 0.3
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                radius: Math.min(width, height) * 0.2

                Image {
                    source: "qrc:///img/previous.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
            }


            onClicked: {
                media_player.seek(media_player.position - 5000)
            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                radius: Math.min(width, height) * 0.2

                Image {
                    id: play_pause_image
                    source: "qrc:///img/play.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
            }


            onClicked: {
                if (playing) {
                    playing = false
                    media_player.pause()
                    play_pause_image.source = "qrc:///img/play.png"
                } else {
                    playing = true
                    media_player.play()
                    play_pause_image.source = "qrc:///img/pause.png"
                }

            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                border.color: "black"
                radius: Math.min(width, height) * 0.2

                Image {
                    source: "qrc:///img/next.png"
                    anchors.fill: parent
                    anchors.margins: 3
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
            }

            onClicked: {
                media_player.seek(media_player.position + 5000)
            }
        }

        Row {
            height: parent.height
            width: parent.width * 0.2
            spacing: parent.width * 0.01

            Text {
                height: parent.height
                width: media_player.position > 360000 ? 84 : (media_player.position > 60000 ? 64 : 44)
                text: TimeFormat.format(media_player.position)
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }

            Text {
                height: parent.height
                text: "/"
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                height: parent.height
                width: media_player.position > 360000 ? 84 : (media_player.position > 60000 ? 64 : 44)
                text: TimeFormat.format(media_player.duration)
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Rectangle {
        height: parent.height * 0.3
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.1

        Item {
            height: parent.height
            width: parent.width * 0.85
            anchors.horizontalCenter: parent.horizontalCenter

            SquareSlider {
                id: slider
                sliderValue: media_player.position
                height: parent.height
                width: media_player.duration / 1000 * secondPixelSize + sliderHandleWidth
                sliderSecondPixelSize: secondPixelSize

                onSeek: {
                    playing = false;
                    media_player.seek(value)
                    media_player.pause()
                    play_pause_image.source = "qrc:///img/play.png"
                }

                onUpdateSubtitleTiming: editSubtitleTiming(previousBegin, newBegin, end)
            }
        }

        SideSliderArea {
            width: parent.width * 0.1
            height: parent.height * 6
            slider: slider
            isDecrease: true
            parentWidth: parent.width
        }

        SideSliderArea {
            width: parent.width * 0.1
            height: parent.height * 2
            anchors.right: parent.right
            slider: slider
            parentWidth: parent.width
        }
    }
}
