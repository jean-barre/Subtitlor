import QtQuick 2.0
import QtQuick.Controls 2.12

import "../common"

Item {

    property StackView stack
    property string viewName: "Edit"
    property string nextItemName: "Export"
    property Item nextItem:

        ExportView {
            stack: stack
        }

    Label {
        text: "Editor View"
    }
}
