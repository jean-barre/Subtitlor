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
    property int logBarHeight: 50

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
                objectName: "uploadView"
            }

        onCurrentItemChanged: mainController.stackViewItemChanged(currentItem.viewName)
    }

    footer: LogBar {
        width: parent.width
        height: logBarHeight
    }

    Item {
        anchors.fill: parent
        visible: mainController.loading

        Rectangle {
            anchors.fill: parent
            color: "white"
            opacity: 0.04
        }

        Rectangle {
            width: parent.width * 0.3
            height: parent.height * 0.3
            anchors.centerIn: parent
            color: "white"
            opacity: 0.18
            radius: Theme.margin
        }

        Label {
            text: "Loading..."
            anchors.centerIn: parent
            font.pointSize: Theme.fontLargePointSize
        }
    }

    Connections {
        target: mainController
        onPerformStackPush: {
            main_stack_view.push(main_stack_view.currentItem.nextItem)
        }
    }
}
