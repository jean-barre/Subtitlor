#include "srtexport.h"

SRTExport::SRTExport(QObject *parent) : QObject(parent)
{
    this->qmlExportObject = parent->findChild<QObject*>("Export");
    createTemporaryFile();
}

SRTExport::SRTExport(QObject *parent, SRTEditor *editor): editor(editor)
{
    this->qmlExportObject = parent->findChild<QObject*>("Export");
    QObject::connect(this->qmlExportObject, SIGNAL(export_file(QString)), this, SLOT(exportFile(QString)));
    createTemporaryFile();
}

SRTExport::~SRTExport()
{
}

void SRTExport::createTemporaryFile()
{
    int subtitlesCount = 1;
    const QString timeFormat = QString("hh:mm:ss,zzz");
    temporaryFile = new QFile(".tmp.srt");
    if (!temporaryFile->open(QIODevice::ReadWrite | QIODevice::Text))
    {
        logMessage(-1, "Building SRT file failure: opening temporary");
        return;
    }

    QTextStream out(temporaryFile);
    out << "\n";
    for (auto pair : this->editor->getSubtitles())
    {
        SubtitleMarker *marker = pair.second;
        QTime begin = QTime(0,0,0).addMSecs(marker->getBeginTime());
        QTime end = begin.addMSecs(marker->getDuration());
        out << subtitlesCount++ << "\n";
        out << begin.toString(timeFormat);
        out << " --> ";
        out << end.toString(timeFormat) << "\n";
        out << marker->getText() << "\n" << "\n";
    }
}

void SRTExport::logMessage(int code, QString error)
{
    QString time = QTime::currentTime().toString("HH:mm");
    QMetaObject::invokeMethod(qmlExportObject, "displayLogMessage",
            Q_ARG(QVariant, code), Q_ARG(QVariant, time), Q_ARG(QVariant, error));
}

void SRTExport::exportFile(QString fileUrl)
{
    fileUrl = fileUrl.split("file://").at(1);
    bool copySuccess = temporaryFile->copy(fileUrl);
    if (copySuccess)
    {
        logMessage(1, "Exporting file success");
    }
    else
    {
        logMessage(-1, "Exporting file failure");
    }
}
