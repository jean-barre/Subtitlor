import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import com.subtitlor.editor 1.0
import com.subtitlor.theme 1.0

import "../../common"

Row {
    width: 600
    height: 400
    spacing: width * 0.05

    Item {

        width: parent.width * 0.7
        height: parent.height * 0.8
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            anchors.fill: parent
            color: Theme.foregroundColor
            opacity: 0.12
        }

        Text {
            id: stext_input_stext_input_text_area_placeholder_text
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Subtitles comes here"
        }

        TextArea {
            id: stext_input_text_area
            anchors.fill: parent
            text: ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textFormat: TextEdit.RichText
            selectByMouse: true
            persistentSelection: true
            wrapMode: TextEdit.WrapAnywhere

            color: "black"

            onActiveFocusChanged: {
                stext_input_stext_input_text_area_placeholder_text.visible = false
            }
        }
    }

    Grid {
        width: parent.width * 0.25
        height: parent.height
        columns: 2
        rows: 2
        columnSpacing: width * 0.05
        rowSpacing: height * 0.05

        Button {
            width: parent.width * 0.45
            height: parent.height * 0.45
            onClicked: stext_input_text_styler.bold = !stext_input_text_styler.bold
            checkable: true
            checked: stext_input_text_styler.bold
            icon.source: "qrc:/img/text_bold.png"
        }

        Button {
            width: parent.width * 0.45
            height: parent.height * 0.45
            onClicked: stext_input_text_styler.italic = !stext_input_text_styler.italic
            checkable: true
            checked: stext_input_text_styler.italic
            icon.source: "qrc:/img/text_italic.png"
        }

        Button {
            width: parent.width * 0.45
            height: parent.height * 0.45
            onClicked: stext_input_text_styler.underline = !stext_input_text_styler.underline
            checkable: true
            checked: stext_input_text_styler.underline
            icon.source: "qrc:/img/text_underline.png"
        }

        Button {
            width: parent.width * 0.45
            height: parent.height * 0.45

            background: Rectangle {
                color: "transparent"
                radius: 5

                Rectangle {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: stext_input_text_styler.textColor
                    radius: 5
                }

                Rainbow {
                    width: height
                    height: parent.height * 0.4
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.7
                }
            }

            onClicked: {
                stext_input_color_dialog.color = stext_input_text_styler.textColor
                stext_input_color_dialog.open()
            }
        }

        ColorDialog {
            id: stext_input_color_dialog
            color: "black"
        }
    }

    TextStyler {
        id: stext_input_text_styler
        target: stext_input_text_area
        cursorPosition: stext_input_text_area.cursorPosition
        selectionStart: stext_input_text_area.selectionStart
        selectionEnd: stext_input_text_area.selectionEnd
        textColor: stext_input_color_dialog.color
    }
}
