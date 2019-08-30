import QtQuick 2.6
import QtMultimedia 5.0
import "common"
import "common/time_format.js" as TimeFormat

Column {
    height: 400
    width: 400
    spacing: height * 0.03
    objectName: "marker_editor"

    property int subtitle_number: 0
    property bool on_marker: false
    property int marker_time: 0
    property int beginTimeValue: on_marker ? marker_time : media_player.position
    property int durationValue: 0
    property MediaPlayer media_player
    signal lookUpIfOnMarker(int timeframe)
    signal addMarker(int beginTime, int duration, string text)
    signal editMarker(int beginTime, int duration, string text)
    signal removeMarker(int beginTime)
    function updateOnMarker(is_on) {
        on_marker = is_on
    }

    function setCurrentMarker(beginTime, duration, text) {
        marker_time = beginTime
        durationValue = duration
        text_editor.text_value.text = text
    }
    Connections {
        target: media_player
        onPositionChanged: {
            marker_editor.lookUpIfOnMarker(media_player.position)
        }
    }

    Row {
        height: parent.height * 0.15
        width: parent.width * 0.7
        spacing: width * 0.2
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: number_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "Subtitle number:"
            }
            Text {
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                anchors.left: number_title.right
                anchors.leftMargin: 10
                text: subtitle_number
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: on_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "On Subtitle:"
            }
            Rectangle {
                height: parent.height / 2
                width: height
                radius: height / 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: on_title.right
                anchors.leftMargin: 10
                color: on_marker ? "green" : "red"
            }
        }
    }

    Row {
        height: parent.height * 0.15
        width: parent.width * 0.7
        spacing: width * 0.2
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: begin_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "Begin time (ms):"
            }
            Text {
                id: begin_value
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                anchors.left: begin_title.right
                anchors.leftMargin: 10
                text: TimeFormat.format(beginTimeValue)
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: duration_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "Marker Duration (ms):"
            }
            Rectangle {
                width: parent.width * 0.5
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: duration_title.right
                anchors.leftMargin: 10
                border.color: "black"

                TextEdit {
                    id: duration_value
                    anchors.fill: parent
                    padding: 10
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: TextEdit.WrapAnywhere
                    text: TimeFormat.format(durationValue)
                }
            }


        }
    }

    Row {
        height: parent.height * 0.40
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter

        TextEditor {
            id: text_editor
            height: parent.height
            width: parent.width
        }
    }

    Row {
        height: parent.height * 0.15
        width: parent.width * 0.95
        spacing: width * 0.2
        anchors.horizontalCenter: parent.horizontalCenter

        RoundButton {
            id: add_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == false
            opacity: on_marker == false ? 1 : 0.4

            background_color: "green"
            button_text: "Add"

            onClicked: {
                addMarker(beginTimeValue, TimeFormat.unformat(duration_value.text), text_editor.text_styler.htmlText)
                marker_editor.lookUpIfOnMarker(media_player.position)
            }
        }

        RoundButton {
            id: edit_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == true
            opacity: on_marker == true ? 1 : 0.4

            background_color: "blue"
            button_text: "Edit"

            onClicked: {
                editMarker(beginTimeValue, TimeFormat.unformat(duration_value.text), text_editor.text_styler.htmlText)
            }
        }

        RoundButton {
            id: remove_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == true
            opacity: on_marker == true ? 1 : 0.4

            background_color: "red"
            button_text: "Remove"

            onClicked: {
                removeMarker(beginTimeValue)
                marker_editor.lookUpIfOnMarker(media_player.position)
            }
        }
    }
}
