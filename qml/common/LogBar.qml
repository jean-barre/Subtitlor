import QtQuick 2.0

Item {
    height: 50
    width: 600


    function displayLogMessage(code, time, message) {
        log_message_time.text = time
        log_message_text.text = message
        switch(code) {
        case -1:
            log_message_text.color = "red"
            break;
        case 0:
            log_message_text.color = "black"
            break;
        case 1:
            log_message_text.color = "green"
            break;
        }
    }

    Rectangle {
        anchors.fill: parent
        border.color: "grey"

        Row {
            anchors.fill: parent
            anchors.margins: 2
            anchors.leftMargin: 10
            spacing: 10

            Text {
                text: "Message :"
                font.pixelSize: 10
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: log_message_time
                font.pixelSize: 10
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: log_message_text
                font.pixelSize: 10
                height: parent.height
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
