import QtQuick 2.0
import QtQuick.Controls 2.1

RangeSlider {
    id: control
    padding: 0

    signal updateFirstValue(int firstValue)
    signal updateSecondValue(int secondValue)

    property int recordFirstValue
    property int recordSecondValue
    property var root

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        z: -1
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: "grey"
        enabled: false

        Rectangle {
            x: control.first.visualPosition * parent.width
            width: control.second.visualPosition * parent.width - x
            height: parent.height
            color: "#0f70be"
            radius: 2
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            z: -1
        }
    }

    first.handle: Rectangle {
        x: first.visualPosition * control.availableWidth
        y: control.topPadding + control.availableHeight / 2 - height / 2
        z: 2
        implicitWidth: 12
        implicitHeight: 14
        radius: 2
        color: first.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"

        Rectangle {
            width: 2
            implicitHeight: 20
            anchors.bottom: parent.bottom
            color: first.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }
    }
    first.onValueChanged: {
        root.updateSubtitleBegin(recordFirstValue, first.value)
        recordFirstValue = first.value
    }

    second.handle: Rectangle {
        x: second.visualPosition * (control.availableWidth) - width
        y: control.topPadding + control.availableHeight / 2 - height / 2
        z: 2
        implicitWidth: 12
        implicitHeight: 14
        radius: 2
        color: second.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"

        Rectangle {
            width: 2
            implicitHeight: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: second.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }
    }
    second.onValueChanged: {
        root.updateSubtitleEnd(first.value, second.value)
    }
}
