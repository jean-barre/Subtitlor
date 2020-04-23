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

void SubtitlesController::setOnSubtitle(const bool onSubtitle)
{
    if (onSubtitle != q_onSubtitle)
    {
        q_onSubtitle = onSubtitle;
        emit onSubtitleChanged();
    }
}

void SubtitlesController::onPlayerPositionChanged(qint64 playerPosition)
{
    // find if there is a subtitle at the media position
    int position = int(playerPosition);
    auto upperIterator = subtitles.upper_bound(position);
    if (upperIterator != subtitles.cbegin())
    {
        upperIterator--;
        SubtitlePtr subtitleFound = static_cast<SubtitlePtr>(upperIterator->second);
        if (subtitleFound->beginTime() <= position &&
                        subtitleFound->beginTime() + subtitleFound->duration() > position)
        {
            setOnSubtitle(true);
            return;
        }
    }
    setOnSubtitle(false);
}

