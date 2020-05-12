import QtQuick 2.5
import QtQuick.Controls 2.0

Button {
    width: 400
    height: 100
    checkable: true

    property string imageSource

    Image {
        width: parent.width * 0.4
        height: parent.height * 0.4
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        mipmap: true
        source: imageSource
    }
}
