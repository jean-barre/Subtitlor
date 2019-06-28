import QtQuick 2.0
import QtMultimedia 5.0

Column {
    height: 400
    width: 400
    spacing: height * 0.03
    objectName: "marker_editor"

    property bool on_marker: false
    property int marker_time: 0
    property MediaPlayer media_player
    signal lookUpIfOnMarker(int timeframe)
    signal addMarker(int beginTime, int duration, string text)
    function updateOnMarker(is_on) {
        on_marker = is_on
    }
    function setCurrentMarker(beginTime, duration, text) {
        marker_time = beginTime
        duration_value.text = duration
        text_value.text = text
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
                text: "Marker number:"
            }
            Text {
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                anchors.left: number_title.right
                anchors.leftMargin: 10
                text: "10"
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: on_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "On Marker:"
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
                text: {
                    if (!on_marker && media_player.position)
                        media_player.position
                    else
                        marker_time
                }
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
                    anchors.leftMargin: 5
                    verticalAlignment: Text.AlignVCenter
                    text: "0"
                }
            }


        }
    }

    Row {
        height: parent.height * 0.40
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            height: parent.height
            width: parent.width
            border.color: "black"

            Text {
                id: initial_text
                anchors.fill: parent
                anchors.margins: 10
                color: "grey"
                text: "Type your subtitles here"
                visible: text_value.text.length == 0
            }

            TextEdit {
                id: text_value
                anchors.fill: parent
                anchors.margins: 10
                color: "black"
                text: ""
            }
        }

    }

    Row {
        height: parent.height * 0.15
        width: parent.width * 0.95
        spacing: width * 0.2
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            id: add_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == false

            Rectangle {
                anchors.fill: parent
                color: "green"
                opacity: on_marker == false ? 1 : 0.4

                Text {
                    anchors.centerIn: parent
                    text: "Add"
                }
            }

            onClicked: {
                opacity = 0.4
                button_animation.target = add_button
                button_animation.start()
                addMarker(begin_value.text, duration_value.text, text_value.text)
            }
        }

        MouseArea {
            id: edit_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == true

            Rectangle {
                anchors.fill: parent
                color: "blue"
                opacity: on_marker == true ? 1 : 0.4

                Text {
                    anchors.centerIn: parent
                    text: "Edit"
                }
            }

            onClicked: {
                opacity = 0.4
                button_animation.target = edit_button
                button_animation.start()
            }
        }

        MouseArea {
            id: remove_button
            height: parent.height
            width: parent.width * 0.2
            enabled: on_marker == true

            Rectangle {
                anchors.fill: parent
                color: "red"
                opacity: on_marker == true ? 1 : 0.4

                Text {
                    anchors.centerIn: parent
                    text: "Remove"
                }
            }

            onClicked: {
                opacity = 0.4
                button_animation.target = remove_button
                button_animation.start()
            }
        }

        NumberAnimation {
            id: button_animation
            property: "opacity"
            to: 1
            duration: 1000
        }
    }
}
