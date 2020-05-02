#include <QFile>
#include <QTime>
#include <QUrl>
#include <QDebug>
#include "srtparser.h"

SRTParser::SRTParser(QString fileURL, std::map<int, SubtitlePtr> *subtitles) :
    fileURL(fileURL), subtitles(subtitles)
{
}

bool SRTParser::parse()
{
    // an integer regular expression used to detect the subtitle index
    QRegExp integerRegularExpression("\\d*");
    // open the file
    QFile file(QUrl(fileURL).toLocalFile());
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit log(QString("SRT file error: " + file.errorString()), Log::LogCode::ERROR);
        return false;
    }
    QTextStream inputStream(&file);
    while (!inputStream.atEnd())
    {
        QString line = inputStream.readLine();
        lineCount++;
        // detect the subtitle index as the beginning of a new subtitle
        if (!line.isEmpty() && (integerRegularExpression.exactMatch(line)))
        {
            if (!parseSubtitle(inputStream))
            {
                return false;
            }
        }
    }
    file.close();
    return true;
}

/*
 * Store the input stream in a QStringList
 * until the first empty line or the end of the file and
 * give it to the parseSubtitleContent
 */
bool SRTParser::parseSubtitle(QTextStream& inputStream)
{
    QStringList subtitleStringList;
    QString line = inputStream.readLine();
    subtitleStringList.append(line);
    while (!inputStream.atEnd() && !line.isEmpty())
    {
        line = inputStream.readLine();
        subtitleStringList.append(line);
        lineCount++;
    }
    return parseSubtitleContent(subtitleStringList);
}

/*
 * Parses an input stream with the format
 * hh:mm.ss,zzz --> hh:mm.ss,zzz
 * text
 * */
bool SRTParser::parseSubtitleContent(QStringList& subtitleString)
{
    const QString timeFormat = "hh:mm:ss,zzz";
    const QTime zeroTime = QTime(0, 0);
    if (!subtitleString.isEmpty())
    {
        // parse time informations
        QString timeString = subtitleString.takeFirst();
        QStringList timeStringList = timeString.split(" --> ");
        if (timeStringList.size() != 2)
        {
            const QString message = "SRT file error: invalid format X --> X at line " +
                QString::number(lineCount - subtitleString.size());
            emit log(message, Log::LogCode::ERROR);
            return false;
        }
        QTime begin = QTime::fromString(timeStringList[0], timeFormat);
        QTime end = QTime::fromString(timeStringList[1], timeFormat);
        if (!begin.isValid() || !end.isValid())
        {
            const QString message = "SRT file error: invalid time format at line " +
                QString::number(lineCount - subtitleString.size());
            emit log(message, Log::LogCode::ERROR);
            return false;
        }
        int beginTime = zeroTime.msecsTo(begin);
        int duration = begin.msecsTo(end);
        // parse text information
        QString text = "";
        for (QString str : subtitleString)
        {
            text += (str + "\r\n");
        }
        // store in the subtitles map
        SubtitlePtr subtitle(new Subtitle(beginTime, duration, text));
        this->subtitles->insert(std::pair<int,SubtitlePtr>(beginTime, subtitle));
        subtitlesCount++;
        return true;
    }
    return true;
}

