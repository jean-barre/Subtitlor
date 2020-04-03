import QtQuick 2.6
import QtQuick.Controls 2.1
import "common"
import "file"

Item {

    property StackView stack

    Column {
        height: parent.height
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            height: parent.height * 0.3
            width: parent.width

            Text {
                width: parent.width * 0.1
                height: parent.height * 0.3
                verticalAlignment: Text.AlignVCenter

                text: "I wish to:"
            }

            Column {
                width: parent.width * 0.9
                height: parent.height

                Item {
                    height: parent.height * 0.2
                    width: parent.width
                }

                RadioButton {
                    id: creationRadioButton
                    height: parent.height * 0.3
                    width: parent.width
                    anchors.left: parent.left

                    text: "Create a SRT file"
                }

                RadioButton {
                    id: editionRadioButton
                    height: parent.height * 0.3
                    width: parent.width
                    anchors.left: parent.left

                    text: "Edit a SRT file"
                }
            }
        }

        Column {
            id: drop_area
            width: parent.width
            height: parent.height * 0.6
            anchors.margins: parent.height * 0.05
            spacing: parent.height * 0.05

            FileDropArea {
                id: video_area
                file_type: 1
                visible: creationRadioButton.checked || editionRadioButton.checked

                height: parent.height * 0.4
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
            }

            FileDropArea {
                id: srt_area
                file_type: 0
                visible: editionRadioButton.checked

                height: parent.height * 0.4
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Item {
            height: parent.height * 0.05
            width: parent.width

            RoundButton {
                height: parent.height
                width: parent.width * 0.3
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.05

                visible: editionRadioButton.checked ? video_area.valid_url && srt_area.valid_url :
                    video_area.valid_url
                background_color: "black"
                button_text: "Start"

                onClicked: {
                    stack.push("qrc:/qml/EditorPage.qml",
                        {
                            stack: stack,
                            objectName:"Edit",
                            video_url: video_area.file_url,
                            srt_url: srt_area.file_url
                        })
                }
            }
        }
    }
}
