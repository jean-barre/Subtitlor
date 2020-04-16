import QtQuick 2.12
import QtGraphicalEffects 1.0
import com.subtitlor.theme 1.0

MouseArea {
    id: root
    width: 1200
    height: 600

    hoverEnabled: true
    propagateComposedEvents: true

    property SSlider slider
    property bool isDecrease: false
    property int parentWidth

    property int moveMultiplier: 1
    property int startPointX: isDecrease ? 0 : width
    property int endPointX: isDecrease ? width : 0
    property bool isActive: (isDecrease && slider.x < 0) ||
                            (!isDecrease && slider.x > root.parentWidth - slider.width)

    onEntered: {
        side_slider_area_timer.start();
    }

    onExited: {
        moveMultiplier = 1;
        side_slider_area_timer.stop();
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
        gradient:

            Gradient {
                GradientStop { position: 0.0; color: Theme.backgroundColor }
                GradientStop { position: 1.0; color: "#00000000" }
            }
    }

    Timer {
        id: side_slider_area_timer
        interval: 5; repeat: true

        onTriggered: {
            if (root.isDecrease && isActive) {
                if (root.moveMultiplier < 3) {
                    root.moveMultiplier++;
                }
                slider.x += Math.pow(root.moveMultiplier, 2)  * 0.8;
            }
            if (!root.isDecrease && isActive) {
                if (root.moveMultiplier < 3) {
                    root.moveMultiplier++;
                }
                slider.x -= Math.pow(root.moveMultiplier, 2) * 0.8;
            }
        }
    }
}
