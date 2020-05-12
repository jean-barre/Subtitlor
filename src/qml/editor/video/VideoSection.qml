import QtQuick 2.0
import QtMultimedia 5.0

Column {
    width: 600
    height: 600
    spacing: height * 0.02

    VideoViewer {
        width: parent.width
        height: parent.height * 0.85
    }

    VideoController {
        width: parent.width
        height: parent.height * 0.13
    }
}
