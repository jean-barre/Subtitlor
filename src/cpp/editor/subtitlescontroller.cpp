#include <QDateTime>
#include <QFile>
#include <QDir>
#include <QTextStream>
#include "subtitlescontroller.h"
#include "srtparser.h"

const QString SubtitlesController::TEMP_EXPORT_FILE = QDir::tempPath() + "/subtitlor.srt";

SubtitlesController::SubtitlesController(QObject *parent) : QObject(parent)
{
    QFile tempFile(TEMP_EXPORT_FILE);
    if (tempFile.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        q_temporarySavingEnabled = true;
    }
}

SubtitlesController::~SubtitlesController()
{
}

int SubtitlesController::subtitleCount() const
{
    return q_subtitleCount;
}

bool SubtitlesController::onSubtitle() const
{
    return q_onSubtitle;
}

bool SubtitlesController::editing() const
{
    return q_editing;
}

bool SubtitlesController::removing() const
{
    return q_removing;
}

QString SubtitlesController::currentSubtitleText() const
{
    return q_currentSubtitleText;
}

QString SubtitlesController::temporaryFileURL() const
{
    return TEMP_EXPORT_FILE;
}

bool SubtitlesController::temporarySavingEnabled() const
{
    return q_temporarySavingEnabled;
}

RangeSlidersController *SubtitlesController::rangeSliders()
{
    return q_rangeSliders;
}

void SubtitlesController::setSubtitleCount(const int subtitleCount)
{
    if (subtitleCount != q_subtitleCount)
    {
        q_subtitleCount = subtitleCount;
        emit subtitleCountChanged();
    }
}

void SubtitlesController::setEditing(const bool editing)
{
    if (editing != q_editing)
    {
        q_editing = editing;
        emit editingChanged();
    }
}

void SubtitlesController::setRemoving(const bool removing)
{
    if (removing != q_removing)
    {
        q_removing = removing;
        emit removingChanged();
    }
}

QString SubtitlesController::getFoundBeginTime()
{
    if (foundSubtitleIterator->second)
    {
        return format(foundSubtitleIterator->second->beginTime());
    }
    return "";
}

QString SubtitlesController::getFoundDuration()
{
    if (foundSubtitleIterator->second)
    {
        return format(foundSubtitleIterator->second->duration());
    }
    return "";
}

QString SubtitlesController::getFoundText()
{
    if (foundSubtitleIterator->second)
    {
        return foundSubtitleIterator->second->text();
    }
    return "";
}

void SubtitlesController::editFound(const QString beginTimeString, const QString durationString, const QString text)
{
    int beginTime = unformat(beginTimeString);
    int duration = unformat(durationString);
    // keep a copy of the orginal subtitle
    SubtitlePtr originalSubtitle = foundSubtitleIterator->second;
    // remove the original subtitle
    subtitles.erase(foundSubtitleIterator);
    setSubtitleCount(q_subtitleCount - 1);
    // try to add a new subtitle with the new values
    if (!addSubtitle(beginTime, duration, text))
    {
        // insert the original subtitle in case of error
        subtitles.insert(std::pair<int, SubtitlePtr>(originalSubtitle->beginTime(),originalSubtitle));
        setSubtitleCount(q_subtitleCount + 1);
    }
    else
    {
        q_rangeSliders->editRangeSlider(originalSubtitle->beginTime(), beginTime, duration);
    }
    if (q_temporarySavingEnabled)
    {
        saveToFile();
    }
}

void SubtitlesController::removeFound()
{
    q_rangeSliders->removeRangeSlider(foundSubtitleIterator->second->beginTime());
    subtitles.erase(foundSubtitleIterator);
    setSubtitleCount(q_subtitleCount - 1);
    emit log("Operation success", Log::LogCode::SUCCESS);
    synchronize();
    if (q_temporarySavingEnabled)
    {
        saveToFile();
    }
}

void SubtitlesController::add(const QString beginTimeString, const QString durationString, const QString text)
{
    int beginTime = unformat(beginTimeString);
    int duration = unformat(durationString);
    if (addSubtitle(beginTime, duration, text))
    {
        q_rangeSliders->addRangeSlider(beginTime, duration);
    }
    if (q_temporarySavingEnabled)
    {
        saveToFile();
    }
}

int SubtitlesController::parseSRTFile(const QString fileURL)
{
    SRTParser parser(fileURL, &subtitles);
    connect(&parser, SIGNAL(log(const QString, Log::LogCode)), this, SIGNAL(log(const QString, Log::LogCode)));
    bool success = parser.parse();
    if (success)
    {
        setSubtitleCount(parser.subtitlesCount);
    }
    return success;
}

QString SubtitlesController::format(int timeInMilliseconds)
{
    return QDateTime::fromMSecsSinceEpoch(timeInMilliseconds).toUTC().toString(timeFormat);
}

int SubtitlesController::unformat(const QString text) const
{
    QTime time = QTime::fromString(text, timeFormat);
    return QTime(0, 0).msecsTo(time);
}

void SubtitlesController::synchronize()
{
    auto upperIterator = subtitles.upper_bound(playerPosition);
    if (upperIterator != subtitles.cbegin())
    {
        upperIterator--;
        SubtitlePtr subtitle = static_cast<SubtitlePtr>(upperIterator->second);
        if (subtitle->beginTime() <= playerPosition &&
                        subtitle->beginTime() + subtitle->duration() > playerPosition)
        {
            setOnSubtitle(true);
            setCurrentSubtitleText(subtitle->text());
            foundSubtitleIterator = static_cast<SubtitleIterator>(upperIterator);
            return;
        }
    }
    setOnSubtitle(false);
    setCurrentSubtitleText("");
}

void SubtitlesController::setOnSubtitle(const bool onSubtitle)
{
    if (onSubtitle != q_onSubtitle)
    {
        q_onSubtitle = onSubtitle;
        emit onSubtitleChanged();
    }
}

void SubtitlesController::setCurrentSubtitleText(const QString text)
{
    if (text != q_currentSubtitleText)
    {
        q_currentSubtitleText = text;
        emit currentSubtitleTextChanged();
    }
}

bool SubtitlesController::addSubtitle(const int beginTime, const int duration, const QString text)
{
    if (beginTime + duration > playerDuration)
    {
        emit log("Operation failure: the timing set overlap the end of the video", Log::LogCode::ERROR);
        return false;
    }
    auto upperIterator = subtitles.upper_bound(beginTime);
    if (upperIterator != subtitles.cend())
    {
        SubtitlePtr subtitle = static_cast<SubtitlePtr>(upperIterator->second);
        if (beginTime + duration > subtitle->beginTime())
        {
            emit log("Operation failure: the subtitle overlap the following one", Log::LogCode::ERROR);
            return false;
        }
    }
    if (upperIterator != subtitles.cbegin())
    {
        upperIterator--;
        SubtitlePtr subtitle = static_cast<SubtitlePtr>(upperIterator->second);
        if (subtitle->beginTime() + subtitle->duration() > beginTime)
        {
            emit log("Operation failure: the subtitle overlap the previous one", Log::LogCode::ERROR);
            return false;
        }
    }
    SubtitlePtr subtitle(new Subtitle(beginTime, duration, text));
    subtitles.insert(std::pair<int, SubtitlePtr>(beginTime, subtitle));
    setSubtitleCount(q_subtitleCount + 1);
    emit log("Operation success", Log::LogCode::SUCCESS);
    synchronize();
    return true;
}

void SubtitlesController::onTimeFormatChanged(const QString newTimeFormat)
{
    timeFormat = newTimeFormat;
}

void SubtitlesController::onPlayerPositionChanged(qint64 position)
{
    // find if there is a subtitle at the media position
    playerPosition = int(position);
    setEditing(false);
    setRemoving(false);
    synchronize();
}

void SubtitlesController::onPlayerDurationChanged(qint64 duration)
{
    playerDuration = int(duration);
    q_rangeSliders->setVideoDuration(duration);
}

void SubtitlesController::saveToFile(const QString fileURL)
{
    int subtitlesCount = 1;
    bool isFinalExport = fileURL.compare(TEMP_EXPORT_FILE);
    QFile *destinationFile = new QFile(fileURL);
    if (destinationFile->exists())
    {
        destinationFile->remove();
    }
    if (!destinationFile->open(QIODevice::ReadWrite | QIODevice::Text))
    {
        if (isFinalExport)
        {
            emit log("Export failure: No write permission in the selected directory",
                     Log::LogCode::ERROR);
        }
        return;
    }

    QTextStream out(destinationFile);
    out << "\n";
    for (auto pair : subtitles)
    {
        SubtitlePtr marker = pair.second;
        QTime begin = QTime(0,0,0).addMSecs(marker->beginTime());
        QTime end = begin.addMSecs(marker->duration());
        out << subtitlesCount++ << "\n";
        out << begin.toString(SRT_TIME_FORMAT);
        out << " --> ";
        out << end.toString(SRT_TIME_FORMAT) << "\n";
        out << marker->text() << "\n" << "\n";
    }
    if (isFinalExport)
    {
        log("Export success", Log::LogCode::SUCCESS);
    }
}
