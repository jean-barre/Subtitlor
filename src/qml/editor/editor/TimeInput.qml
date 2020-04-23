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
    property bool canBeSetToPosition: false

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

    MouseArea {
        id: time_input_helper_mouse_area
        width: parent.width * 0.1
        height: parent.height * 0.35
        anchors.verticalCenter: parent.verticalCenter
        visible: canBeSetToPosition
        enabled: canBeSetToPosition
        hoverEnabled: true

        Rectangle {
            width: parent.width * 0.5
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: time_input_helper_stick.top
            radius: width * 0.5
            color: Theme.accentColor
        }

        Rectangle {
            id: time_input_helper_stick
            width: 2
            height: parent.height
            anchors.centerIn: parent
            color: Theme.accentColor
        }

        Rectangle {
            id: time_input_helper_message
            width: 140
            height: 25
            anchors.bottom: parent.top
            anchors.bottomMargin: Theme.margin * 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            color: "black"
            radius: 5
            visible: time_input_helper_mouse_area.containsMouse

            Label {
                anchors.fill: parent
                text: "Set to Player position"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: Theme.fontSmallPointSize
            }
        }

        onClicked: {
            root.text = mainController.editor.video.mediaObject.formattedPosition
        }
    }
}
