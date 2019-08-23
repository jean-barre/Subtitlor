import QtQuick 2.6
import QtQuick.Controls 2.1

Rectangle {
    id: rectangle
    color: "black"
    height: 100
    width: 400

    property StackView stack

    MouseArea {
        id: back_button
        height: parent.height * 0.7
        width: parent.width / 6
        anchors.verticalCenter: parent.verticalCenter

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:///img/back.png"
            mipmap: true
        }

        onClicked: {
            stack.pop();
        }
    }

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
            if (stack.depth <= 1) {
                back_button.enabled = false
                back_button.visible = false
            } else {
                back_button.enabled = true
                back_button.visible = true
            }

            if (stack.currentItem) {
                page_title.text = stack.currentItem.objectName
            }
        }
    }
}
