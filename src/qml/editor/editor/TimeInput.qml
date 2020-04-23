import QtQuick 2.12
import QtQuick.Controls 2.12
import com.subtitlor.editor 1.0
import com.subtitlor.theme 1.0

TextField {
    id: root
    width: 100
    height: 50
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: defaultText
    font.pointSize: Theme.fontLargePointSize
    color: state === "" ? Theme.foregroundColor :
                  Theme.errorColor

    state: time_input_controller.isValid ? "" : "INVALID"

    property string defaultText

    TimeInputController {
        id: time_input_controller
        text: root.text
        format: mainController.editor.video.mediaObject.timeFormat
    }

    Text {
        id: time_input_invalid_text
        width: parent.width
        height: parent.height * 0.2
        anchors.top: parent.bottom
        horizontalAlignment: Text.AlignHCenter
        opacity: 0
        text: "Use the format: " + defaultText
        color: Theme.errorColor
        font.pointSize: Theme.fontSmallPointSize
    }

    states: [
        State {
            name: "INVALID"
            PropertyChanges {
                target: time_input_invalid_text
                opacity: 1
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { target: time_input_invalid_text; property: "opacity"; duration: 2000 }
    }
}
