import QtQuick 2.0
import QtQuick.Controls 2.0
import com.subtitlor.theme 1.0

import "common"

Item {
    id: root

    property StackView stack
    property bool hasNextItem: typeof stack.currentItem.nextItem !== 'undefined'

    Label {
        width: parent.width * 0.6
        height: parent.height
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: stack.currentItem.viewName
        font.pointSize: Theme.fontLargePointSize
        font.styleName: "Bold"
    }

    SButton {
        width: parent.width * 0.1
        height: parent.height
        anchors.right: parent.right
        enabled: hasNextItem
        visible: hasNextItem

        onClicked: {
            mainController.triggerStackPush(stack.currentItem.objectName)
        }
        text: hasNextItem ? stack.currentItem.nextItemName : ""
        iconSource: "qrc:/img/navigation_next.png"
        iconSizeRatio: 0.3
    }
}
