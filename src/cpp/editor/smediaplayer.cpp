#include <QDateTime>
#include "smediaplayer.h"

SMediaPlayer::SMediaPlayer(QObject *parent) : QMediaPlayer(parent)
{
    connect(this, SIGNAL(error(QMediaPlayer::Error)),
            this, SLOT(errorOccured(QMediaPlayer::Error)));
    connect(this, SIGNAL(durationChanged(qint64)),
            this, SLOT(onDurationChanged(qint64)));
    connect(this, SIGNAL(positionChanged(qint64)),
            this, SLOT(onPositionChanged(qint64)));
    connect(this, SIGNAL(mediaStatusChanged(QMediaPlayer::MediaStatus)),
            this, SLOT(onMediaStatusChanged(QMediaPlayer::MediaStatus)));
}

int SMediaPlayer::sduration() const
{
    return q_sduration;
}

QString SMediaPlayer::timeFormat() const
{
    return q_timeFormat;
}

QString SMediaPlayer::formattedPosition() const
{
    return q_formattedPosition;
}

QString SMediaPlayer::formattedDuration() const
{
    return q_formattedDuration;
}

QString SMediaPlayer::format(int timeInMilliseconds)
{
    return QDateTime::fromMSecsSinceEpoch(timeInMilliseconds).toUTC().toString(q_timeFormat);
}

void SMediaPlayer::updateSduration()
{
    int duration = this->duration();
    if (duration != q_sduration)
    {
        q_sduration = duration;
        emit sdurationChanged();
    }
}

void SMediaPlayer::setTimeFormat(const QString &timeFormat)
{
    q_timeFormat = timeFormat;
    emit timeFormatChanged(q_timeFormat);
    updateSduration();
}

void SMediaPlayer::setFormattedPosition(const QString &position)
{
    if (position != q_formattedPosition)
    {
        q_formattedPosition = position;
        emit formattedPositionChanged();
    }
}

void SMediaPlayer::setFormattedDuration(const QString &duration)
{
    if (duration != q_formattedDuration)
    {
        q_formattedDuration = duration;
        emit formattedDurationChanged();
    }
}

void SMediaPlayer::errorOccured(QMediaPlayer::Error error)
{
    switch(error)
    {
    case QMediaPlayer::Error::ResourceError:
        emit eventOccured("The video URL could not be resolved", Log::ERROR);
        break;
    case QMediaPlayer::Error::FormatError:
        emit eventOccured("The video format is not supported", Log::ERROR);
        break;
    case QMediaPlayer::Error::AccessDeniedError:
        emit eventOccured("Give read access to your media", Log::ERROR);
        break;
    default:
        break;
    }
}

void SMediaPlayer::onDurationChanged(qint64 duration)
{
    // set the time format
    if (duration < MINUT_IN_MS)
    {
        setTimeFormat(SECONDS_TIME_FORMAT);
    }
    else
    {
        setTimeFormat(MINUTS_TIME_FORMAT);
    }
    // update the formatted duration
    setFormattedDuration(format(duration));
    // update the formatted position
    setFormattedPosition(format(this->position()));
    // check the video duration
    if (duration >= HOUR_IN_MS)
    {
        emit eventOccured("The video duration exceed the 1h limit",
                          Log::ERROR);
    }
}

void SMediaPlayer::onPositionChanged(qint64 position)
{
    setFormattedPosition(format(position));
}

void SMediaPlayer::onMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    switch(status)
    {
    case QMediaPlayer::MediaStatus::LoadedMedia:
        emit mediaLoaded();
        break;
    default:
        break;
    }
}
