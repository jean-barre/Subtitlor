import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import com.subtitlor.editor 1.0
import com.subtitlor.theme 1.0

import "../../common"

Row {
    width: 600
    height: 400
    spacing: width * 0.05

    function setText(text) {
        stext_input_text_area_placeholder_text.visible = false
        stext_input_text_area.text = text
    }

    function text() {
        return stext_input_text_styler.htmlText
    }

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
            id: stext_input_text_area_placeholder_text
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
                stext_input_text_area_placeholder_text.visible = false
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

        SCheckableButton {
            width: parent.width * 0.45
            height: parent.height * 0.45
            onClicked: stext_input_text_styler.bold = !stext_input_text_styler.bold
            checked: stext_input_text_styler.bold
            imageSource: "qrc:/img/text_bold.png"
        }

        SCheckableButton {
            width: parent.width * 0.45
            height: parent.height * 0.45
            onClicked: stext_input_text_styler.italic = !stext_input_text_styler.italic
            checked: stext_input_text_styler.italic
            imageSource: "qrc:/img/text_italic.png"
        }

        SCheckableButton {
            width: parent.width * 0.45
            height: parent.height * 0.45
            onClicked: stext_input_text_styler.underline = !stext_input_text_styler.underline
            checked: stext_input_text_styler.underline
            imageSource: "qrc:/img/text_underline.png"
        }

        Button {
            id: control
            width: parent.width * 0.45
            height: parent.height * 0.45

            background: Rectangle {
                color: stext_input_text_styler.textColor
                radius: 2

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: stext_input_text_styler.textColor
                    color: (stext_input_text_styler.textColor === "#000000") ? "black" : Theme.foregroundColor
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
