import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import com.jeanbarre.subtitlor 1.0

Row {
    height: 400
    width: 600
    spacing: height * 0.02

    property TextArea text_value: text_area
    property TextStyler text_styler: styler

    Item {
        height: parent.height
        width: parent.width * 0.75

        Rectangle {
            anchors.fill: parent
            color: "grey"
            opacity: 0.4
        }

        TextArea {
            id: text_area
            anchors.fill: parent
            color: "black"
            text: ""
            textFormat: TextEdit.RichText
            selectByMouse: true
            persistentSelection: true
            wrapMode: TextEdit.WrapAnywhere
        }

        Text {
            anchors.fill: parent
            text: text_area.contentWidth == 0 ? "Subtitles go here" : ""
            font.italic: true
            padding: text_area.padding
            leftPadding: text_area.leftPadding
        }
    }

    Grid {
        height: parent.height
        width: parent.width * 0.25
        columns: 2
        rows: 2
        spacing: parent.height * 0.02

        ImageButton {
            height: parent.height * 0.5 - parent.spacing * 0.5
            width: parent.width * 0.5 - parent.spacing * 0.5
            onClicked: styler.bold = !styler.bold
            checkable: true
            checked: styler.bold
            imageSource: "qrc:///img/text_bold.png"
        }

        ImageButton {
            height: parent.height * 0.5 - parent.spacing * 0.5
            width: parent.width * 0.5 - parent.spacing * 0.5
            onClicked: styler.italic = !styler.italic
            checkable: true
            checked: styler.italic
            imageSource: "qrc:///img/text_italic.png"
        }

        ImageButton {
            height: parent.height * 0.5 - parent.spacing * 0.5
            width: parent.width * 0.5 - parent.spacing * 0.5
            onClicked: styler.underline = !styler.underline
            checkable: true
            checked: styler.underline
            imageSource: "qrc:///img/text_underline.png"
        }

        Button {
            height: parent.height * 0.5 - parent.spacing * 0.5
            width: parent.width * 0.5 - parent.spacing * 0.5

            Rectangle {
                height: parent.height * 0.9
                width: parent.width
                color: styler.textColor
            }

            Rainbow {
                height: parent.height * 0.1
                width: parent.width
                anchors.bottom: parent.bottom
                opacity: 0.7
            }
            onClicked: {
                colorDialog.color = styler.textColor
                colorDialog.open()
            }
        }

        ColorDialog {
            id: colorDialog
            color: "black"
        }
    }

    TextStyler {
        id: styler
        target: text_area
        cursorPosition: text_area.cursorPosition
        selectionStart: text_area.selectionStart
        selectionEnd: text_area.selectionEnd
        textColor: colorDialog.color
    }
}

