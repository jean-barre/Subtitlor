import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: HomePage {
            stack: stack
            objectName: "Home"
        }
    }

    NavigationBar {
        id: navigation_bar
        width: parent.width
        height: parent.height / 10
        stack: stack
    }
}
