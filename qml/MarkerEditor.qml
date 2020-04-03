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
    property bool editing: false
    property bool removing: false
    property MediaPlayer media_player

    signal lookUpIfOnMarker(int timeframe)
    signal addSubtitle(int beginTime, int duration, string text)
    signal editSubtitle(int previousBeginTime, int beginTime, int duration, string text)
    signal removeSubtitle(int beginTime)

    function updateOnMarker(is_on) {
        on_marker = is_on
        editing = false
        removing = false
    }

    function setCurrentMarker(beginTime, duration, text) {
        marker_time = beginTime
        durationValue = duration
        text_editor.text_value.text = text

        begin_value.setText(TimeFormat.format(beginTime))
        duration_value.setText(TimeFormat.format(duration))
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

            TimeEdit {
                id: begin_value
                width: parent.width * 0.5
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: begin_title.right
                anchors.leftMargin: 10
                defaultTextValue: "00.000"
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: duration_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "Marker Duration (s):"
            }

            TimeEdit {
                id: duration_value
                width: parent.width * 0.5
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: duration_title.right
                anchors.leftMargin: 10
                defaultTextValue: "01.000"
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
                addSubtitle(TimeFormat.unformat(begin_value.timeEditTextEdit.text), TimeFormat.unformat(duration_value.timeEditTextEdit.text), text_editor.text_styler.htmlText)
            }
        }

        RoundButton {
            id: edit_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == true
            opacity: on_marker == true ? 1 : 0.4

            background_color: editing ? "black" : "blue"
            button_text: editing ? "Save" : "Edit"

            onClicked: {
                if (editing) {
                    editSubtitle(beginTimeValue, TimeFormat.unformat(begin_value.timeEditTextEdit.text), TimeFormat.unformat(duration_value.timeEditTextEdit.text), text_editor.text_styler.htmlText)
                    editing = false
                } else {
                    marker_editor.lookUpIfOnMarker(media_player.position)
                    editing = true
                }
            }
        }

        RoundButton {
            id: remove_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == true
            opacity: on_marker == true ? 1 : 0.4

            background_color: removing ? "black" : "red"
            button_text: removing ? "Confirm" : "Remove"

            onClicked: {
                if (removing) {
                    removeSubtitle(beginTimeValue)
                    removing = false
                } else {
                    marker_editor.lookUpIfOnMarker(media_player.position)
                    removing = true
                }
            }
        }
    }
}
