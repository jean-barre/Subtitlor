import QtQuick 2.0
import QtQuick.Controls 2.12

import "../export"
import "video"
import "timeline"
import "editor"

Column {
    spacing: height * 0.03

    property StackView stack
    property string viewName: "Edit"
    property string nextItemName: "Export"
    property Item nextItem:

        ExportView {
            stack: stack
        }

    property string video_url
    property string srt_url
    property bool temporaryFileAccess: true

    VideoSection {
        width: parent.width
        height: parent.height * 0.4
    }

    TimelineSection {
        width: parent.width
        height: parent.height * 0.1
    }

    EditorSection {
        width: parent.width
        height: parent.height * 0.44
    }
}
