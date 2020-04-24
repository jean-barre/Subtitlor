#include <QDateTime>
#include "subtitlescontroller.h"

SubtitlesController::SubtitlesController(QObject *parent) : QObject(parent)
{
}

SubtitlesController::~SubtitlesController()
{
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
    // try to add a new subtitle with the new values
    if (!addSubtitle(beginTime, duration, text))
    {
        // insert the original subtitle in case of error
        subtitles.insert(std::pair<int, SubtitlePtr>(originalSubtitle->beginTime(),originalSubtitle));
    }
}

void SubtitlesController::removeFound()
{
    subtitles.erase(foundSubtitleIterator);
    emit log("Operation success", Log::LogCode::SUCCESS);
    synchronize();
}

void SubtitlesController::add(const QString beginTimeString, const QString durationString, const QString text)
{
    int beginTime = unformat(beginTimeString);
    int duration = unformat(durationString);
    addSubtitle(beginTime, duration, text);
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
    synchronize();
}

void SubtitlesController::onPlayerDurationChanged(qint64 duration)
{
    playerDuration = int(duration);
}

