import QtQuick 2.6
import QtQuick.Controls 2.1
import "common"

Item {
    id: root
    property StackView stack

    Column {
        height: root.height * 0.3
        width: root.width
        anchors.centerIn:parent
        spacing: root.height * 0.1

        RoundButton {
            height: root.height * 0.1
            width: root.width * 0.3
            anchors.horizontalCenter: parent.horizontalCenter

            background_color: "black"
            button_text: "Create a SRT file"

            onClicked: {
                stack.push("qrc:/qml/UploadPage.qml", {stack: stack, objectName:"Upload"})
            }
        }

        RoundButton {
            height: root.height * 0.1
            width: root.width * 0.3
            anchors.horizontalCenter: parent.horizontalCenter

            background_color: "black"
            button_text: "Edit a SRT file"

            onClicked: {
                stack.push("qrc:/qml/UploadPage.qml", {stack: stack, objectName:"Upload"})
            }
        }
    }

}
