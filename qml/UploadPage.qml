import QtQuick 2.6
import QtQuick.Controls 2.1
import "common"

Item {

    property StackView stack
    property bool edit_mode: false

    Column {
        id: drop_area
        width: parent.width * 0.8
        anchors.fill: parent
        anchors.margins: parent.height * 0.05
        spacing: parent.height * 0.05

        FileDropArea {
            id: video_area
            file_type: 1

            height: parent.height * 0.4
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
        }

        FileDropArea {
            id: srt_area
            file_type: 0
            visible: edit_mode

            height: parent.height * 0.4
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    RoundButton {
        height: parent.height * 0.1
        width: parent.width * 0.3
        anchors.right: drop_area.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05

        enabled: edit_mode ? video_area.valid_url && srt_area.valid_url :
            video_area.valid_url
        background_color: "black"
        button_text: "Start Editing"

        onClicked: {
            stack.push("qrc:/qml/EditorPage.qml",
                {
                    stack: stack,
                    objectName:"Edit",
                    video_url: video_area.file_url,
                    srt_url: srt_area.file_url
                })
        }
    }
}
