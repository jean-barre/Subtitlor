#include <QUrl>
#include "file.h"

const QList<QString> File::videoExtensions = {"mp4", "avi", "mov"};
const QList<QString> File::srtExtensions = {"srt"};

File::File(QObject *parent, FileType fileType) : QObject(parent),
    q_fileURL(""), fileType(fileType)
{
    if (fileType == FileType::VIDEO)
    {
        q_extensions = videoExtensions;
    }
    else
    {
        q_extensions = srtExtensions;
    }
}

QString File::fileURL() const
{
    return q_fileURL;
}

QString File::filename() const
{
    return QUrl(q_fileURL).toLocalFile();
}

QList<QString> File::extensions() const
{
    return q_extensions;
}

void File::setFileURL(const QString& fileURL)
{
    if (fileURL != q_fileURL)
    {
        q_fileURL = fileURL;
        emit fileURLChanged();
    }
}

bool File::isValid() const
{
    return !q_fileURL.isEmpty();
}

void File::tryFileURL(const QString& fileURL)
{
    const QString extension = fileURL.split(".").last();
    if (q_extensions.contains(extension))
    {
        setFileURL(fileURL);
    }
}
