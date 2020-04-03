import QtQuick 2.0
import QtGraphicalEffects 1.0

MouseArea {
    id: mouse_area
    width: 1200
    height: 600

    hoverEnabled: true
    propagateComposedEvents: true

    property SquareSlider slider
    property bool isDecrease: false
    property int parentWidth

    property int moveMultiplier: 1
    property int startPointX: isDecrease ? 0 : width
    property int endPointX: isDecrease ? width : 0
    property bool isActive: (isDecrease && slider.x < 0) || (!isDecrease && slider.x > mouse_area.parentWidth * 0.85 - slider.width)

    onEntered: {
        side_slider_timer.start();
    }

    onExited: {
        moveMultiplier = 1;
        side_slider_timer.stop();
    }

    onClicked: {
        mouse.accepted = false
    }

    LinearGradient {
        width: parent.width
        height: parent.height * 1.5
        anchors.verticalCenter: parent.verticalCenter
        visible: isActive
        start: Qt.point(startPointX, 0)
        end: Qt.point(endPointX, 0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "white" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    Timer {
        id: side_slider_timer
        interval: 5; repeat: true
        onTriggered: {
            if (mouse_area.isDecrease && isActive) {
                if (mouse_area.moveMultiplier < 3) {
                    mouse_area.moveMultiplier++;
                }
                slider.x += Math.pow(mouse_area.moveMultiplier, 2)  * 0.8;
            }
            if (!mouse_area.isDecrease && isActive) {
                if (mouse_area.moveMultiplier < 3) {
                    mouse_area.moveMultiplier++;
                }
                slider.x -= Math.pow(mouse_area.moveMultiplier, 2) * 0.8;
            }
        }
    }
}
