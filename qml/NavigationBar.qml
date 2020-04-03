import QtQuick 2.6
import QtQuick.Controls 2.1

Rectangle {
    id: rectangle
    color: "black"
    height: 100
    width: 400

    property StackView stack

    Text {
        id: page_title
        text: "Page Title"
        font.pointSize: 22
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    Connections {
        target: stack
        onCurrentItemChanged: {
            if (stack.currentItem) {
                page_title.text = stack.currentItem.objectName
            }
        }
    }
}
