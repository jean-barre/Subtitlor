#include "srtexport.h"

SRTExport::SRTExport(QObject *parent) : QObject(parent)
{
    this->qmlExportObject = parent->findChild<QObject*>("Export");
}

SRTExport::SRTExport(QObject *parent, SRTEditor *editor): QObject(parent), editor(editor)
{
    this->parent = parent;
}

void SRTExport::initialize()
{
    this->qmlExportObject = parent->findChild<QObject*>("Export");
    QObject::connect(this->qmlExportObject,
            SIGNAL(check_existing_file(QString)),
            this, SLOT(checkExistingFile(QString)));
    QObject::connect(this->qmlExportObject,
            SIGNAL(export_file(QString)),
            this,
            SLOT(exportFile(QString)));
    checkExistingFile(QQmlProperty::read(this->qmlExportObject, "file_url").toString());
}

SRTExport::~SRTExport()
{
}

void SRTExport::logMessage(int code, QString error)
{
    QString time = QTime::currentTime().toString("HH:mm");
    QMetaObject::invokeMethod(qmlExportObject, "displayLogMessage",
            Q_ARG(QVariant, code), Q_ARG(QVariant, time), Q_ARG(QVariant, error));
}

void SRTExport::checkExistingFile(QString fileUrl)
{
    bool exists = false;
    if (!fileUrl.isEmpty()) {
        fileUrl = fileUrl.remove("file://");
        exists = QFile::exists(fileUrl);
    }
    qmlExportObject->setProperty("existing_file", exists);
}

void SRTExport::exportFile(QString fileUrl)
{
    int subtitlesCount = 1;
    const QString timeFormat = QString("hh:mm:ss,zzz");
    QStringList split = fileUrl.split("file://");
    if (split.length() < 2)
    {
        logMessage(-1, "Building SRT file failure: please make sure you gave a correct filename / directory");
        return;
    }
    QFile *targetFile = new QFile(split.at(1));
    if (targetFile->exists())
    {
        targetFile->remove();
    }
    if (!targetFile->open(QIODevice::ReadWrite | QIODevice::Text))
    {
        logMessage(-1, "Building SRT file failure: cannot create a file in the directory selected");
        return;
    }

    QTextStream out(targetFile);
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
    logMessage(1, "Exporting file success");
}
