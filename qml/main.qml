import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.0

Window {
    visible: true
    width: 850
    height: 600
    title: qsTr("Hello World")

    NavigationBar {
        id: navigation_bar
        height: parent.height * 0.1
        width: parent.width
        stack: stack
    }

    StackView {
        id: stack
        anchors.top: navigation_bar.bottom
        height: parent.height * 0.9
        width: parent.width
        initialItem: HomePage {
            stack: stack
            objectName: "Home"
        }
    }
}
