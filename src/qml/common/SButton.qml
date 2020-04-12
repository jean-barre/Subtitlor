import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import com.subtitlor.theme 1.0

MouseArea {
    id: sbutton_root
    width: 300
    height: 100

    property string text
    property string iconSource
    property double iconSizeRatio: 0.8
    property string defaultAnchorSide: "anchorRight"

    property bool hasText: text.length > 0
    property bool hasImage: iconSource.length > 0

    Label {
        anchors.fill: parent
        horizontalAlignment: hasImage ? Text.AlignLeft : Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: sbutton_root.text
        font.pointSize: Theme.fontPointSize
        color: Theme.accentColor
    }

    Image {
        id: sbutton_image
        width: parent.width * iconSizeRatio
        height: parent.height * iconSizeRatio
        fillMode: Image.PreserveAspectFit
        state: hasText ? sbutton_root.defaultAnchorSide : "anchorCenter"
        anchors.rightMargin: Theme.margin
        anchors.leftMargin: Theme.margin
        anchors.verticalCenter: parent.verticalCenter
        source: iconSource
        mipmap: true

        states: [
            State {
                name: "anchorRight"

                AnchorChanges {
                    target: sbutton_image
                    anchors.right: parent.right
                    anchors.horizontalCenter: undefined
                }
            },
            State {
                name: "anchorLeft"

                AnchorChanges {
                    target: sbutton_image
                    anchors.left: parent.left
                    anchors.horizontalCenter: undefined
                }
            },
            State {
                name: "anchorCenter"

                AnchorChanges {
                    target: sbutton_image
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        ]
    }

    ColorOverlay {
        anchors.fill: sbutton_image
        source: sbutton_image
        color: Theme.accentColor
    }
}
