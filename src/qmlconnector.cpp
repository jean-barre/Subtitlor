#include "qmlconnector.h"

QMLConnector::QMLConnector(QObject *parent) : QObject(parent)
{
    QObject::connect(parent, SIGNAL(itemChanged(QString)), this, SLOT(makeConnections(QString)));
}

void QMLConnector::makeConnections(QString objectName)
{
    if (objectName == "Edit") {
        if (!this->srtEditor)
        {
            this->srtEditor = new SRTEditor(this->parent());
        }
    } else if (objectName == "Export") {
        this->srtExport = new SRTExport(this->parent(), this->srtEditor);
    }
}
