import QtQuick 2.6
import QtGraphicalEffects 1.0

Rectangle {
    height: 400
    width: 400
    radius: width / 2
    color: "white"

    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(parent.width, 0)
        source: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "red" }
            GradientStop { position: 0.2; color: "orange" }
            GradientStop { position: 0.4; color: "yellow" }
            GradientStop { position: 0.6; color: "green" }
            GradientStop { position: 0.8; color: "blue" }
            GradientStop { position: 1.0; color: "purple" }
        }
    }
}
