import QtQuick 2.6
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.0
import com.subtitlor.theme 1.0

import "../common"

DropArea {

    // File type code: 0 = SRT, 1 = Video
    property int file_type
    property string type_name: file_type == 0 ? "SRT" : "Video"
    property string type_icon: file_type == 0 ? "qrc:///img/srt_icon.png" : "qrc:///img/video_icon.png"
    property var type_extensions: file_type == 0 ? ["srt"] : ["mov", "avi", "mp4"]
    property string file_url
    property bool valid_url: false

    Pane {
        anchors.fill: parent
        padding: 0

        Rectangle {
            anchors.fill: parent

            color: "white"
            opacity: 0.08
        }

        Column {
            anchors.centerIn: parent
            height: parent.height * 0.7
            width: parent.width
            spacing: height * 0.1

            Image {
                height: parent.height * 0.2
                width: parent.width
                fillMode: Image.PreserveAspectFit
                source: type_icon
                mipmap: true
            }

            SRectangleButton {
                width: parent.width * 0.2
                height: parent.height * 0.15
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Open file..."

                onClicked: {
                    file_dialog.visible = true
                }
            }

            Label {
                width: parent.width
                height: parent.height * 0.15
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: "or Drop your " + type_name + " file here"
                font.pointSize: Theme.fontLargePointSize
            }

            Item {
                width: parent.width
                height: parent.height * 0.15

                Label {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    visible: !valid_url

                    text: "No file"
                    font.pointSize: Theme.fontPointSize
                    opacity: 0.14
                }

                Label {
                    id: file_name
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    visible: valid_url

                    text: ""
                    font.pointSize: Theme.fontPointSize
                }
            }
        }

        Label {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.margin
            anchors.right: parent.right
            anchors.rightMargin: Theme.margin
            text: "extensions: " + type_extensions
            font.pointSize: Theme.fontSmallPointSize
        }
    }

    FileDialog {
        id: file_dialog
        title: type_name + " file selection"
        folder: shortcuts.home

        onAccepted: {
            if (validateFileExtension(file_dialog.fileUrls[0])) {
                file_name.text = file_dialog.fileUrls[0]
                file_url = file_dialog.fileUrls[0]
                valid_url = true
            } else {
                valid_url = false
            }
        }
        onRejected: {
        }
    }

    onDropped: {
        if (drop.hasUrls) {
            if (validateFileExtension(drop.urls[0])) {
                file_name.text = drop.urls[0]
                file_url = drop.urls[0]
                valid_url = true
            } else {
                valid_url = false
            }
        } else {
            valid_url = false
        }
    }

    function validateFileExtension(filePath) {
        var extension = filePath.split('.').pop().toUpperCase()
        for(var i = 0; i < type_extensions.length; i++) {
            var type_extension = type_extensions[i]
            if (type_extension.toUpperCase() === extension)
                return true
        }
        return false
    }
}
