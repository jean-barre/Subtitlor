import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import com.subtitlor.theme 1.0

import "../common"

Column {
    id: export_view_columnn
    spacing: height * 0.04

    property string viewName: "Export"

    Item {
        width: parent.width - 2 * Theme.margin
        height: parent.height * 0.3
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            color: "white"
            opacity: 0.08
        }

        Column {
            anchors.fill: parent
            spacing: height * 0.2

            Label {
                height: parent.height * 0.3
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: "File name"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                height: parent.height * 0.3
                width: parent.width * 0.6
                spacing: Theme.margin
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: export_view_file_name
                    height: parent.height
                    width: parent.width * 0.8
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: mainController.srtExport.filename
                    wrapMode: TextEdit.WrapAnywhere
                    selectByMouse: true

                    onTextChanged: {
                        mainController.srtExport.filename = text
                    }
                }

                Label {
                    height: parent.height
                    width: parent.width * 0.2
                    anchors.baseline: export_view_file_name.baseline
                    text: ".srt"
                    font.bold: true
                }
            }
        }
    }

    Item {
        width: parent.width - 2 * Theme.margin
        height: parent.height * 0.3
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            color: "white"
            opacity: 0.08
        }

        Column {
            anchors.fill: parent
            spacing: height * 0.2

            Label {
                height: parent.height * 0.3
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Directory"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                height: parent.height * 0.3
                width: parent.width * 0.6
                spacing: parent.width * 0.05
                anchors.horizontalCenter: parent.horizontalCenter

                Item {
                    height: parent.height
                    width: parent.width * 0.65

                    Label {
                        id: export_view_directory_url
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        text: mainController.srtExport.directoryURL
                        wrapMode: TextEdit.WrapAnywhere
                    }
                }

                SRectangleButton {
                    height: parent.height
                    width: parent.width * 0.3
                    text: "Select ..."

                    onClicked: {
                        export_view_file_dialog.visible = true
                    }
                }
            }
        }
    }

    Column {
        width: parent.width
        height: parent.height * 0.14

        Label {
            width: parent.width
            height: parent.height * 0.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Destination : " + mainController.srtExport.destinationURL
        }

        Label {
            width: parent.width
            height: parent.height * 0.5
            visible: mainController.srtExport.overriding
            text: "A file already exist at this location. By exporting you would overwrite it."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Theme.errorColor
        }
    }

    SRectangleButton {
        width: parent.width * 0.2
        height: parent.height * 0.14
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Export File"

        onClicked: {
            mainController.srtExport.exportSRT()
        }
    }

    FileDialog {
        id: export_view_file_dialog
        title: "Please choose a file"
        folder: shortcuts.home
        selectFolder: true
        onAccepted: {
            mainController.srtExport.directoryURL = export_view_file_dialog.fileUrls[0]
        }
        onRejected: {
        }
    }
}
