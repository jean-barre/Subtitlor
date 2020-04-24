import QtQuick 2.12
import com.subtitlor.theme 1.0

import "../../common"

Column {
    width: 400
    height: 400
    spacing: height * 0.05

    property bool onSubtitle: mainController.editor.subtitles.onSubtitle
    property bool editing: mainController.editor.subtitles.editing
    property bool removing: mainController.editor.subtitles.removing

    EditorSectionHeader {
        width: parent.width * 0.5
        height: parent.height * 0.15
        anchors.horizontalCenter: parent.horizontalCenter
    }

    EditorInput {
        id: editor_section_editor_input
        width: parent.width - 2 * Theme.margin
        height: parent.height * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Row {
        width: parent.width - 2 * Theme.margin
        height: parent.height * 0.15
        spacing: width * 0.2
        anchors.horizontalCenter: parent.horizontalCenter

        SRectangleButton {
            width: parent.width * 0.2
            height: parent.height
            enabled: onSubtitle == false
            opacity: onSubtitle == false ? 1 : 0.4

            text: "Add"

            onClicked: {
                editor_section_editor_input.add()
            }
        }

        SRectangleButton {
            width: parent.width * 0.2
            height: parent.height
            enabled: onSubtitle == true
            opacity: onSubtitle == true ? 1 : 0.4

            text: editing ? "Save" : "Edit"

            onClicked: {
                if (editing) {
                    editor_section_editor_input.edit()
                }
                mainController.editor.subtitles.editing = !editing
            }
        }

        SRectangleButton {
            width: parent.width * 0.2
            height: parent.height
            enabled: onSubtitle == true
            opacity: onSubtitle == true ? 1 : 0.4

            text: removing ? "Confirm" : "Remove"

            onClicked: {
                if (removing) {
                    mainController.editor.subtitles.removeFound()
                }
                mainController.editor.subtitles.removing = !removing
            }
        }
    }
}
