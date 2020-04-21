import QtQuick 2.12
import com.subtitlor.theme 1.0

import "../../common"

Column {
    width: 400
    height: 400
    spacing: height * 0.05

    property bool onSubtitle: false
    property bool editing: false
    property bool removing: false

    EditorSectionHeader {
        width: parent.width * 0.5
        height: parent.height * 0.15
        anchors.horizontalCenter: parent.horizontalCenter
    }

    EditorInput {
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
        }

        SRectangleButton {
            width: parent.width * 0.2
            height: parent.height
            enabled: onSubtitle == true
            opacity: onSubtitle == true ? 1 : 0.4

            text: editing ? "Save" : "Edit"
        }

        SRectangleButton {
            width: parent.width * 0.2
            height: parent.height
            enabled: onSubtitle == true
            opacity: onSubtitle == true ? 1 : 0.4

            text: removing ? "Confirm" : "Remove"
        }
    }
}
