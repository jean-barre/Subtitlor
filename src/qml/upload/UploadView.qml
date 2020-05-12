import QtQuick 2.0
import QtQuick.Controls 2.0
import com.subtitlor.theme 1.0

import "../editor"

Item {

    property string viewName: "Upload"
    property string nextItemName: "Edit"
    property Item nextItem: EditorView {}

    Column {
        anchors.fill: parent
        anchors.margins: Theme.margin

        Row {
            height: parent.height * 0.3
            width: parent.width

            Label {
                width: parent.width * 0.1
                height: parent.height * 0.3
                verticalAlignment: Text.AlignVCenter

                text: "What would you like to do?"
                font.pointSize: Theme.fontPointSize
            }

            Column {
                width: parent.width * 0.9
                height: parent.height

                Item {
                    height: parent.height * 0.2
                    width: parent.width
                }

                RadioButton {
                    height: parent.height * 0.3
                    width: parent.width
                    anchors.left: parent.left

                    checked: true
                    text: "Create a SRT file"
                    font.pointSize: Theme.fontPointSize

                    onCheckedChanged: {
                        if (checked) {
                            mainController.upload.editionUseCase = false
                        }
                    }
                }

                RadioButton {
                    height: parent.height * 0.3
                    width: parent.width
                    anchors.left: parent.left

                    text: "Edit a SRT file"
                    font.pointSize: Theme.fontPointSize

                    onCheckedChanged: {
                        if (checked) {
                            mainController.upload.editionUseCase = true
                        }
                    }
                }
            }
        }

        Row {
            width: parent.width
            height: parent.height * 0.6
            anchors.margins: Theme.margin
            spacing: Theme.margin

            FileDropArea {
                width: parent.width * 0.5 - Theme.margin / 2
                height: parent.height

                fileURL: mainController.upload.videoFile.fileURL
                imageSource: "qrc:/img/video_icon.png"
                typeName: "Video"
                extensions: mainController.upload.videoFile.extensions
                onTryFileURL: mainController.upload.videoFile.tryFileURL(fileURL)
            }

            FileDropArea {
                width: parent.width * 0.5 - Theme.margin / 2
                height: parent.height
                visible: mainController.upload.editionUseCase

                fileURL: mainController.upload.srtFile.fileURL
                imageSource: "qrc:/img/srt_icon.png"
                typeName: "SRT"
                extensions: mainController.upload.srtFile.extensions
                onTryFileURL: mainController.upload.srtFile.tryFileURL(fileURL)
            }
        }
    }
}
