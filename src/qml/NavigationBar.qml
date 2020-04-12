import QtQuick 2.0
import QtQuick.Controls 2.12

Item {

    property StackView stack
    property bool hasItemBefore: stack.depth > 1
    property bool hasNextItem: typeof stack.currentItem.nextItem !== 'undefined'

    Button {
        width: parent.width * 0.2
        height: parent.height
        enabled: hasItemBefore
        visible: hasItemBefore
        onClicked: stack.pop()

        icon.source: "qrc:/img/navigation_previous.png"
    }

    Text {
        width: parent.width * 0.6
        height: parent.height
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: stack.currentItem.viewName
    }

    Button {
        width: parent.width * 0.2
        height: parent.height
        anchors.right: parent.right
        enabled: hasNextItem
        visible: hasNextItem
        text: hasNextItem ? stack.currentItem.nextItemName : ""
        onClicked: stack.push(stack.currentItem.nextItem)

        icon.source: "qrc:/img/navigation_next.png"
    }
}
