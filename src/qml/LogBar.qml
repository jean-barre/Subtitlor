import QtQuick 2.0
import QtQuick.Controls 2.0
import com.subtitlor.theme 1.0
import com.subtitlor.log 1.0

Item {
    width: 500
    height: 100

    Row {
        width: parent.width - (2 * Theme.margin)
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.margin

        Label {
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            visible: mainController.logMessage.length > 0
            text: "Message : "
        }

        Label {
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: mainController.logMessage
            color: (mainController.logCode === Log.SUCCESS) ? Theme.successColor :
                   ((mainController.logCode === Log.ERROR) ? Theme.errorColor :
                                                             Theme.foregroundColor)
        }
    }
}
