import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import "view"

Window {
    visible: true
    width: mainController.screenWidth
    height: mainController.screenHeight
    title: qsTr("Subtitlor")

    property var navigationBarHeight: 100

    NavigationBar {
        id: main_navigation_bar
        width: parent.width
        height: navigationBarHeight
        stack: main_stack_view
    }

    StackView {
        id: main_stack_view
        width: parent.width
        height: parent.height - navigationBarHeight
        anchors.top: main_navigation_bar.bottom
        initialItem:

            UploadView {
                stack: main_stack_view
            }
    }
}
