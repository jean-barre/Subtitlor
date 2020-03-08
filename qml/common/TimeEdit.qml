import QtQuick 2.0

Item {
    property TextEdit timeEditTextEdit: time_edit_text_edit
    property string defaultTextValue

    function setText(text)
    {
        time_edit_text_edit.text = text
    }

    Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.4
    }

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: time_edit_text_edit.text.length == 0
        text: "01.000"
        color: "grey"
        font.underline: true
        font.pointSize: 20
    }

    TextEdit {
        id: time_edit_text_edit
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        focus: true
        font.underline: true
        font.pointSize: 20
        text: defaultTextValue

        onTextChanged: {
            if (text.length == 0) {
                text = defaultTextValue
            }
        }
    }
}
