import QtQuick 2.6
import QtQuick.Controls 2.1
import "common"

Item {

    property StackView stack

    RoundButton {
        height: parent.height * 0.1
        width: parent.width * 0.3
        anchors.centerIn: parent

        background_color: "black"
        button_text: "Create SRT file"

        onClicked: {
            stack.push("qrc:/qml/UploadPage.qml", {stack: stack, objectName:"Upload"})
        }
    }
}
