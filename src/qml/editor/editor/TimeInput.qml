import QtQuick 2.12
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0

Item {
    property string defaultTextValue

    TextField {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        focus: true
        text: defaultTextValue
        font.pointSize: Theme.fontLargePointSize

        onTextChanged: {
            if (text.length == 0) {
                text = defaultTextValue
            }
        }
    }
}
