import QtQuick 2.6
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.0
import com.subtitlor.theme 1.0

import "../common"

DropArea {

    property string fileURL
    property string imageSource
    property string typeName
    property var extensions

    signal tryFileURL(string fileURL)

    Pane {
        anchors.fill: parent
        padding: 0

        Rectangle {
            anchors.fill: parent

            color: "white"
            opacity: 0.08
        }

        Column {
            width: parent.width
            height: parent.height * 0.7
            anchors.centerIn: parent
            spacing: height * 0.1

            Image {
                width: parent.width
                height: parent.height * 0.2
                fillMode: Image.PreserveAspectFit
                source: imageSource
                mipmap: true
            }

            SRectangleButton {
                width: parent.width * 0.2
                height: parent.height * 0.15
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Open file..."

                onClicked: {
                    file_drop_area_file_dialog.visible = true
                }
            }

            Label {
                width: parent.width
                height: parent.height * 0.15
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: "or Drop your " + typeName + " file here"
                font.pointSize: Theme.fontLargePointSize
            }

            Item {
                width: parent.width
                height: parent.height * 0.15

                Label {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    visible: file_drop_area_file_name.text.length === 0

                    text: "No file"
                    font.pointSize: Theme.fontPointSize
                    opacity: 0.14
                }

                Label {
                    id: file_drop_area_file_name
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    text: fileURL
                    font.pointSize: Theme.fontPointSize
                }
            }
        }

        Label {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.margin
            anchors.right: parent.right
            anchors.rightMargin: Theme.margin
            text: "extensions: " + extensions
            font.pointSize: Theme.fontSmallPointSize
        }
    }

    FileDialog {
        id: file_drop_area_file_dialog
        title: typeName + " file selection"
        folder: shortcuts.home

        onAccepted: {
            tryFileURL(file_drop_area_file_dialog.fileUrls[0])
        }
    }

    onDropped: {
        if (drop.hasUrls) {
            tryFileURL(drop.urls[0])
        }
    }
}
