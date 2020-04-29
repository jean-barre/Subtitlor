#include "exportcontroller.h"
#include <QFile>
#include <QUrl>

ExportController::ExportController(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(filenameChanged()), this, SLOT(updateDestinationURL()));
    connect(this, SIGNAL(directoryURLChanged()), this, SLOT(updateDestinationURL()));
}

QString ExportController::filename() const
{
    return q_filename;
}

QString ExportController::directoryURL() const
{
    return q_directoryURL;
}

bool ExportController::overriding() const
{
    return q_overriding;
}

QString ExportController::destinationURL() const
{
    return q_destinationURL;
}

void ExportController::setFilename(const QString filename)
{
    if (filename != q_filename)
    {
        q_filename = filename;
        emit filenameChanged();
    }
}

void ExportController::setDirectoryURL(const QString directoryURL)
{
    if (directoryURL != q_directoryURL)
    {
        q_directoryURL = QUrl(directoryURL).toLocalFile();
        emit directoryURLChanged();
    }
}

void ExportController::setOverriding(const bool overriding)
{
    if (overriding != q_overriding)
    {
        q_overriding = overriding;
        emit overridingChanged();
    }
}

void ExportController::updateDestinationURL()
{
    q_destinationURL = q_directoryURL + "/" + q_filename + ".srt";
    emit destinationURLChanged();
    setOverriding(QFile::exists(q_destinationURL));
}
