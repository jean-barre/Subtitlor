import QtQuick 2.6
import QtQuick.Dialogs 1.0

DropArea {

    // File type code: 0 = SRT, 1 = Video
    property int file_type
    property string type_name: file_type == 0 ? "SRT" : "Video"
    property string type_icon: file_type == 0 ? "qrc:///img/srt_icon.png" : "qrc:///img/video_icon.png" 
    property var type_extensions: file_type == 0 ? ["srt"] : ["mov", "avi", "mp4"]
    property string file_url
    property bool valid_url: false

    Rectangle {
        anchors.fill: parent
        border.color: "black"
        radius: 5

        Column {
            anchors.centerIn: parent
            height: parent.height * 0.7
            width: parent.width * 0.7
            spacing: parent.height * 0.05

            Image {
                height: parent.height * 0.45
                width: parent.width
                fillMode: Image.PreserveAspectFit
                source: type_icon
                mipmap: true
            }

            Text {
                height: parent.height * 0.25
                width: parent.width
                text: "Drop your " + type_name + " file here"
                font.pointSize: 16
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "black"
            }

            Row {
                width: parent.width
                height: parent.height * 0.20
                spacing: parent.height * 0.02

                Item {
                    width: parent.width * 0.68
                    height: parent.height

                    Text {
                        anchors.fill: parent
                        color: "grey"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: "No file"
                        visible: !valid_url
                    }

                    Text {
                        id: file_name
                        anchors.fill: parent
                        color: "blue"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: ""
                        visible: valid_url
                    }
                }

                RoundButton {
                    width: parent.width * 0.3
                    height: parent.height
                    button_text: "Open file..."

                    onClicked: {
                        file_dialog.visible = true
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
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            text: "extensions: " + type_extensions
            font.pointSize: 10
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
            if (type_extension.toUpperCase() == extension)
                return true
        }
        return false
    }
}
