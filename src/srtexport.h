#ifndef SRTEXPORT_H
#define SRTEXPORT_H

#include <QObject>
#include <QFile>

#include "srteditor.h"

class SRTExport : public QObject
{
    Q_OBJECT
public:
    explicit SRTExport(QObject *parent = nullptr);
    SRTExport(QObject *parent, SRTEditor *editor);
    void initialize();
    ~SRTExport();

private:
    QObject *parent;
    SRTEditor *editor;
    QString destinationFile;
    QObject *qmlExportObject;

    void logMessage(int code, QString message);

signals:

public slots:
    void checkExistingFile(QString fileUrl);
    void exportFile(QString fileUrl);
};

#endif // SRTEXPORT_H
