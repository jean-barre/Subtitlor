import QtQuick 2.0
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0

import "../editor"

Item {

    property StackView stack
    property string viewName: "Upload"
    property string nextItemName: "Edit"
    property Item nextItem:

        EditorView {
            stack: stack
        }

    Column {
        anchors.fill: parent
        anchors.margins: Theme.margin

        Row {
            height: parent.height * 0.3
            width: parent.width

            Label {
                width: parent.width * 0.1
                height: parent.height * 0.3
                verticalAlignment: Text.AlignVCenter

                text: "What would you like to do?"
                font.pointSize: Theme.fontPointSize
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
                    font.pointSize: Theme.fontPointSize
                }

                RadioButton {
                    id: editionRadioButton
                    height: parent.height * 0.3
                    width: parent.width
                    anchors.left: parent.left

                    text: "Edit a SRT file"
                    font.pointSize: Theme.fontPointSize
                }
            }
        }

        Row {
            id: drop_area
            width: parent.width
            height: parent.height * 0.6
            anchors.margins: Theme.margin
            spacing: Theme.margin

            FileDropArea {
                id: video_area
                file_type: 1
                visible: creationRadioButton.checked || editionRadioButton.checked

                height: parent.height
                width: parent.width * 0.5 - Theme.margin / 2
            }

            FileDropArea {
                id: srt_area
                file_type: 0
                visible: editionRadioButton.checked

                height: parent.height
                width: parent.width * 0.5 - Theme.margin / 2
            }
        }
    }
}
