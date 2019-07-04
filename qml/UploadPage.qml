import QtQuick 2.6
import QtQuick.Controls 2.1
import "common"

Item {

    property StackView stack
    property string video_url

    DropArea {
        id: drop_area
        height: parent.height * 0.6
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.1

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
                    source: "qrc:///img/video_icon.png"
                }

                Text {
                    height: parent.height * 0.25
                    width: parent.width
                    text: "Drop your Video file here"
                    font.pointSize: 16
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "black"
                }

                Item {
                    height: parent.height * 0.20
                    width: parent.width

                    Text {
                        anchors.fill: parent
                        color: "grey"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "No file"
                        visible: file_name.text.length === 0
                    }

                    Text {
                        id: file_name
                        anchors.fill: parent
                        color: "black"
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        text: ""
                    }
                }
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                text: "accepted extensions: .mov, .avi and .mp4"
                font.pointSize: 10
            }
        }

        onDropped: {
            if (drop.hasUrls) {
                if (validateFileExtension(drop.urls[0])) {
                    file_name.text = drop.urls[0]
                    video_url = drop.urls[0]
                }
            }
        }

        function validateFileExtension(filePath) {
            var extension = filePath.split('.').pop()
            return extension === "avi" || extension === "mp4" || extension === "mov"
        }
    }

    RoundButton {
        height: parent.height * 0.1
        width: parent.width * 0.3
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.1

        background_color: "black"
        button_text: "Start Editing"

        onClicked: {
            stack.push("qrc:/qml/EditorPage.qml", {stack: stack, objectName:"Edit", video_url: video_url})
        }
    }
}
