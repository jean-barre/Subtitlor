#include "smediaplayer.h"

SMediaPlayer::SMediaPlayer(QObject *parent) : QMediaPlayer(parent)
{
    connect(this, SIGNAL(error(QMediaPlayer::Error)),
            this, SLOT(errorOccured(QMediaPlayer::Error)));
    connect(this, SIGNAL(durationChanged(qint64)),
            this, SLOT(onDurationChanged(qint64)));
    connect(this, SIGNAL(mediaStatusChanged(QMediaPlayer::MediaStatus)),
            this, SLOT(onMediaStatusChanged(QMediaPlayer::MediaStatus)));
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
    if (duration >= 3600000)
    {
        emit eventOccured("The video duration exceed the 1h limit",
                          Log::ERROR);
    }
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
