import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.1

Window {
    visible: true
    width: 1200
    height: 900
    title: qsTr("Subtitlor")

    NavigationBar {
        id: navigation_bar
        height: parent.height * 0.1
        width: parent.width
        stack: stack
    }

    StackView {
        id: stack
        objectName: "stack_view"
        anchors.top: navigation_bar.bottom
        height: parent.height * 0.9
        width: parent.width
        initialItem: UploadPage {
            stack: stack
            objectName: "Upload"
        }
        onCurrentItemChanged: {
            if (currentItem)
            {
                itemChanged(currentItem.objectName)
            }
        }
        Component.onCompleted: {
            currentItemChanged()
        }

        signal itemChanged(string itemName)
    }
}
