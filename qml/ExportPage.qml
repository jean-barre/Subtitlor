import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.0
import "common"

Item {

    property StackView stack
    property string file_url
    signal export_file(string file_url)
    function displayLogMessage(code, time, message) {
        log_bar.displayLogMessage(code, time, message)
    }

    Column {
        anchors.centerIn: parent
        height: parent.height * 0.6
        width: parent.width * 0.8
        spacing: height * 0.07

        Text {
            height: parent.height * 0.07
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "File name"
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            height: parent.height * 0.07
            width: parent.width * 0.5
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                height: parent.height
                width: parent.width * 0.8
                border.color: "black"

                Text {
                    anchors.fill: parent
                    padding: 10
                    color: "grey"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    text: "myVideoSubtitles"
                    visible: file_name.text.length === 0
                }

                TextEdit {
                    id: file_name
                    anchors.fill: parent
                    padding: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    wrapMode: TextEdit.WrapAnywhere
                }
            }

            Text {
                height: parent.height
                width: parent.width * 0.2
                verticalAlignment: Text.AlignVCenter
                text: ".srt"
                font.bold: true
            }
        }

        Text {
            height: parent.height * 0.07
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Directory"
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            height: parent.height * 0.07
            width: parent.width
            spacing: parent.width * 0.05
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                height: parent.height
                width: parent.width * 0.65
                border.color: "black"

                Text {
                    anchors.fill: parent
                    padding: 10
                    color: "grey"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    text: "..."
                    visible: directory_url.text.length === 0
                }

                TextEdit {
                    id: directory_url
                    anchors.fill: parent
                    padding: 10
                    readOnly: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    text: ""
                    wrapMode: TextEdit.WrapAnywhere
                }
            }

            RoundButton {
                height: parent.height
                width: parent.width * 0.3
                button_text: "Select"

                onClicked: {
                    file_dialog.visible = true
                }
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.2
        height: parent.height * 0.1
        width: parent.width * 0.8
        spacing: width * 0.2

        RoundButton {
            height: parent.height
            width: parent.width * 0.4
            button_text: "Export File"
            onClicked: {
                export_file(directory_url.text + "/" + file_name.text + ".srt")
            }
        }

        RoundButton {
            height: parent.height
            width: parent.width * 0.4
            button_text: "Go Home"

            onClicked: {
                stack.pop(stack.find(function(item) {
                    return item.name === "Home";
                }));
            }
        }
    }

    LogBar {
        id: log_bar
        height: parent.height * 0.03
        width: parent.width
        anchors.bottom: parent.bottom
    }

    FileDialog {
        id: file_dialog
        title: "Please choose a file"
        folder: shortcuts.home
        selectFolder: true
        onAccepted: {
            directory_url.text = file_dialog.fileUrls[0]
        }
        onRejected: {
        }
    }

    Component.onCompleted: {
        if (file_url != "") {
            var n = file_url.lastIndexOf("/");
            file_name.text = file_url.substring(n+1, file_url.length - 4)
            directory_url.text = file_url.substring(0, n)
        }
    }
}
