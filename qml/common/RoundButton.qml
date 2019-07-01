import QtQuick 2.0

MouseArea {
    id: root

    property color background_color
    property string button_text: "Button"
    property color text_color: "white"
    property int text_size: 12

    height: 100
    width: 400

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: background_color
        radius: Math.min(root.height, root.width) * 0.2

        Text {
            anchors.fill: parent
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: text_color
            text: button_text
            font.pixelSize: text_size
            wrapMode: TextEdit.WrapAnywhere
        }
    }

    onClicked: {
        rectangle.opacity = 0.4
        button_animation.start()
    }

    NumberAnimation {
        id: button_animation
        target: rectangle
        property: "opacity"
        to: 1
        duration: 1000
    }
}
