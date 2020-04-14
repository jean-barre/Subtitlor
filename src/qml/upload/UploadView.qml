import QtQuick 2.0
import QtQuick.Controls 2.12
import com.subtitlor.theme 1.0

import "../editor"

Item {

    property StackView stack
    property string viewName: "Upload"
    property string nextItemName: "Edit"
    property Item nextItem:

        EditorView {
            stack: stack
        }

    Label {
        text: "Upload View"
    }
}
