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
                text: "Edit page"
                color: "white"
            }
        }

        onClicked: {
            stack.pop(stack.find(function(item) {
                return item.name === "Home";
            }))
        }
    }
}
