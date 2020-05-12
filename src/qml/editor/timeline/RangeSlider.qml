import QtQuick 2.0
import QtQuick.Controls 2.0
import com.subtitlor.theme 1.0

RangeSlider {
    id: control
    width: 200
    height: 50
    padding: 0

    signal firstValueChanged(int firstValue)
    signal secondValueChanged(int secondValue)

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: control.availableHeight
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: "transparent"
        enabled: false

        Rectangle {
            id: time_range_slider_duration_rectangle
            x: control.first.visualPosition * parent.width
            width: control.second.visualPosition * parent.width - x
            height: parent.height
            color: Theme.accentColor
            radius: 2
        }
    }

    first.objectName: "first"

    first.handle: Item {
        x: first.visualPosition * control.availableWidth
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 12
        implicitHeight: control.availableHeight

        Rectangle {
            width: height
            height: parent.height * 0.3
            anchors.centerIn: parent
            color: Theme.backgroundColor
            radius: height / 2
        }
    }

    Rectangle {
        width: 70
        height: 25
        anchors.top: first.handle.bottom
        anchors.topMargin: Theme.margin * 0.5
        anchors.horizontalCenter: first.handle.horizontalCenter
        color: "black"
        radius: 5
        visible: first.hovered

        Label {
            anchors.fill: parent
            text: "--." + Math.floor(first.value).toString().slice(-3)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: Theme.fontSmallPointSize
        }
    }

    first.onPressedChanged: {
        if (!first.pressed) {
            firstValueChanged(first.value)
        }
    }

    second.objectName: "second"

    second.handle: Item {
        x: second.visualPosition * (control.availableWidth) - width
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 12
        implicitHeight: control.availableHeight

        Rectangle {
            width: height
            height: parent.height * 0.3
            anchors.centerIn: parent
            color: Theme.backgroundColor
            radius: height / 2
        }
    }

    Rectangle {
        width: 70
        height: 25
        anchors.top: second.handle.bottom
        anchors.topMargin: Theme.margin * 0.5
        anchors.horizontalCenter: second.handle.horizontalCenter
        color: "black"
        radius: 5
        visible: second.hovered

        Label {
            anchors.fill: parent
            text: "--." + Math.floor(second.value).toString().slice(-3)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: Theme.fontSmallPointSize
        }
    }

    second.onPressedChanged: {
        if (!second.pressed) {
            secondValueChanged(second.value)
        }
    }

    MouseArea {
        anchors.left: background.left
        anchors.right: first.handle.left
        anchors.verticalCenter: background.verticalCenter
        height: background.height
    }
    MouseArea {
        x: first.visualPosition * parent.width + first.handle.width
        width: second.visualPosition * parent.width - x - second.handle.width
        anchors.verticalCenter: background.verticalCenter
        height: background.height
    }

    MouseArea {
        anchors.left: second.handle.right
        anchors.right: background.right
        anchors.verticalCenter: background.verticalCenter
        height: background.height
    }
}
