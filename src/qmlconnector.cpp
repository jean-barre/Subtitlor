#include "qmlconnector.h"

QMLConnector::QMLConnector(QObject *parent) : QObject(parent)
{
    QObject::connect(parent, SIGNAL(itemChanged(QString)), this, SLOT(makeConnections(QString)));
    srtEditor = new SRTEditor(parent);
    srtExport = new SRTExport(parent, srtEditor);
}

void QMLConnector::makeConnections(QString objectName)
{
    if (objectName == "Edit") {
        srtEditor->initialize();
    } else if (objectName == "Export") {
        srtExport->initialize();
    }
}
