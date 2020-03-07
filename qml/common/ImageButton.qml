import QtQuick 2.6
import QtQuick.Controls 2.1

Button {
    width: 100
    height: 100

    property string imageSource: "qrc:///img/text_bold.png"

    Image {
        anchors.fill: parent
        anchors.margins: parent.width * 0.2
        source: imageSource
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }
}
