import QtQuick 2.0
import QtQuick.Controls 1.0
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
            stack.push({item: upload_page, properties: {stack: stack, objectName:"Upload"}})
        }
        Component{
            id: upload_page
            UploadPage {}
        }
    }
}
