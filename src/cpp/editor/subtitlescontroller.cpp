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

QString SubtitlesController::format(int timeInMilliseconds)
{
    return QDateTime::fromMSecsSinceEpoch(timeInMilliseconds).toUTC().toString(timeFormat);
}

void SubtitlesController::setOnSubtitle(const bool onSubtitle)
{
    if (onSubtitle != q_onSubtitle)
    {
        q_onSubtitle = onSubtitle;
        emit onSubtitleChanged();
    }
}

void SubtitlesController::onTimeFormatChanged(const QString newTimeFormat)
{
    timeFormat = newTimeFormat;
}

void SubtitlesController::onPlayerPositionChanged(qint64 playerPosition)
{
    // find if there is a subtitle at the media position
    int position = int(playerPosition);
    auto upperIterator = subtitles.upper_bound(position);
    if (upperIterator != subtitles.cbegin())
    {
        upperIterator--;
        SubtitlePtr subtitle = static_cast<SubtitlePtr>(upperIterator->second);
        if (subtitle->beginTime() <= position &&
                        subtitle->beginTime() + subtitle->duration() > position)
        {
            setOnSubtitle(true);
            foundSubtitleIterator = static_cast<SubtitleIterator>(upperIterator);
            return;
        }
    }
    setOnSubtitle(false);
}

