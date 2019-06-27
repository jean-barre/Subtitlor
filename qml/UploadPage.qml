import QtQuick 2.0
import QtQuick.Controls 1.0

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

            Column {
                anchors.centerIn: parent
                height: parent.height * 0.7
                width: parent.width * 0.7
                spacing: parent.height * 0.1

                Image {
                    height: parent.height * 0.45
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:///img/video_icon.png"
                }

                Text {
                    text: "Drop your Video file here"
                    font.pointSize: 13
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    height: parent.height * 0.45
                    width: parent.width
                    color: "black"
                }
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                text: "accepted extensions: .avi and .mp4"
                font.pointSize: 8
            }
        }

        onDropped: {
            if (drop.hasUrls) {
                if (validateFileExtension(drop.urls[0])) {
                    file_url.text = drop.urls[0]
                    video_url = drop.urls[0]
                }
            }
        }

        function validateFileExtension(filePath) {
            var extension = filePath.split('.').pop()
            return extension === "avi" || extension === "mp4"
        }
    }

    Text {
        id: file_url
        height: parent.height * 0.15
        width: parent.width * 0.4
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.1
        text: "File name ..."
        wrapMode: Text.WordWrap
        color: "grey"
    }

    MouseArea {
        height: parent.height * 0.15
        width: parent.width * 0.2
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.1

        Rectangle {
            color: "black"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                text: "Upload"
                color: "white"
            }
        }

        onClicked: {
            stack.push({item: editor_page, properties: {stack: stack, objectName:"Edit", video_url: video_url}})
        }

        Component{
            id: editor_page
            EditorPage {}
        }
    }

}
