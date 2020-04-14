import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import com.subtitlor.theme 1.0

import "upload"

ApplicationWindow {
    visible: true
    width: mainController.screenWidth
    height: mainController.screenHeight
    title: qsTr("Subtitlor")

    property var navigationBarHeight: 100

    Material.theme: Material.Dark
    Material.primary: Theme.primaryColor
    Material.background: Theme.backgroundColor
    Material.foreground: Theme.foregroundColor
    Material.accent: Theme.accentColor

    header: NavigationBar {
        id: main_navigation_bar
        width: parent.width
        height: navigationBarHeight
        stack: main_stack_view
    }

    StackView {
        id: main_stack_view
        anchors.fill: parent
        initialItem:

            UploadView {
                stack: main_stack_view
                objectName: "uploadView"
            }
    }

    Connections {
        target: mainController
        onPerformStackPush: {
            main_stack_view.push(main_stack_view.currentItem.nextItem)
        }
    }
}
