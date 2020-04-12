import QtQuick 2.0
import QtQuick.Controls 2.12

Item {

    property StackView stack
    property string viewName: "Upload"
    property string nextItemName: "Edit"
    property Item nextItem:

        EditorView {
            stack: stack
        }

    Text {
        text: "Upload View"
    }
}
