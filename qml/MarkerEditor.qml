import QtQuick 2.0

Column {
    height: 400
    width: 400
    spacing: height * 0.03

    property bool on_marker: false

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
                text: "Begin time:"
            }
            Text {
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                anchors.left: begin_title.right
                anchors.leftMargin: 10
                text: "00:10:35"
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * 0.4
            Text {
                id: duration_title
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "Marker Duration:"
            }
            Text {
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: duration_title.right
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                text: "00:08"
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
            }

            TextEdit {
                anchors.fill: parent
                anchors.margins: 10
                color: "black"
                text: ""
                onFocusChanged: {
                    initial_text.visible = false
                }
            }
        }

    }

    Row {
        height: parent.height * 0.15
        width: parent.width * 0.95
        spacing: width * 0.2
        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                color: "green"

                Text {
                    anchors.centerIn: parent
                    text: "Add"
                }
            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                color: "blue"

                Text {
                    anchors.centerIn: parent
                    text: "Edit"
                }
            }
        }

        MouseArea {
            height: parent.height
            width: parent.width * 0.2

            Rectangle {
                anchors.fill: parent
                color: "red"

                Text {
                    anchors.centerIn: parent
                    text: "Remove"
                }
            }
        }
    }
}
