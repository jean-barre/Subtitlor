import QtQuick 2.0
import QtQuick.Controls 1.0

Item {

    property StackView stack

    MouseArea {
        width: 150
        height: 60
        anchors.centerIn: parent

        Rectangle {
            color: "black"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                text: "Create SRT file"
                color: "white"
            }
        }

        onClicked: {
            stack.push({item: upload_page, properties: {stack: stack, objectName:"Upload"}})
        }

        Component{
            id: upload_page
            UploadPage {}
        }
    }
}
