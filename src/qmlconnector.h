#ifndef QMLCONNECTOR_H
#define QMLCONNECTOR_H

#include <QObject>
#include "srteditor.h"
#include "srtexport.h"

class QMLConnector : public QObject
{
    Q_OBJECT
public:
    explicit QMLConnector(QObject *parent = nullptr);

private:
    QObject *markerEditorQML;
    SRTEditor *srtEditor;
    SRTExport *srtExport;

signals:

public slots:
    void makeConnections(QString objectName);
};

#endif // QMLCONNECTOR_H
