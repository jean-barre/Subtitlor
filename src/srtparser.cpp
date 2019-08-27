#include "srtparser.h"
#include <QDebug>

SRTParser::SRTParser(QString filePath, std::map<int, SubtitleMarker*> *subtitles) {
    if (filePath.isEmpty()) {
        return;
    } else {
        filePath = filePath.remove("file://");
    }
    this->subtitles = subtitles;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug()<<file.errorString();
        return;
    }
    QTextStream inputStream(&file);
    parse(&inputStream);
    file.close();
}

SRTParser::~SRTParser() {
}

void SRTParser::parse(QTextStream *inputStream)
{
    QRegExp integerRegularExpression("\\d*");
    while (!inputStream->atEnd())
    {
        QString line = inputStream->readLine();
        // detect new subtitle and parse it
        if (!line.isEmpty() && (integerRegularExpression.exactMatch(line)))
        {
            parseSubtitle(inputStream);
        }
    }
}

void SRTParser::parseSubtitle(QTextStream *inputStream)
{
    QStringList subtitleString = {};
    QStringList &subtitleStringRef = subtitleString;
    while (!inputStream->atEnd())
    {
        QString line = inputStream->readLine();
        if (line.isEmpty())
        {
            storeSubtitle(subtitleStringRef);
            return;
        }
        else
        {
            subtitleString.append(line);
        }
    }
}

void SRTParser::storeSubtitle(QStringList &subtitleString)
{
    const QString timeFormat = "hh:mm:ss,zzz";
    const QTime zeroTime = QTime(0, 0);
    if (!subtitleString.isEmpty())
    {
        // Parse time informations
        QString timeString = subtitleString.takeFirst();
        QStringList timeStringList = timeString.split(" --> ");
        if (timeStringList.size() != 2)
        {
            qDebug()<<"Invalid subtitle time format";
            return;
        }
        QTime begin = QTime::fromString(timeStringList[0], timeFormat);
        QTime end = QTime::fromString(timeStringList[1], timeFormat);
        int beginTime = zeroTime.msecsTo(begin);
        int duration = begin.msecsTo(end);
        // Parse text information
        QString text = "";
        for (QString str : subtitleString)
        {
            text += (str + "\r\n");
        }
        // Store in the Editor map
        SubtitleMarker *marker = new SubtitleMarker(beginTime, duration, text);
        this->subtitles->insert(std::pair<int,SubtitleMarker*>(beginTime, marker));
    }
}

