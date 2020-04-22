#ifndef SMEDIAPLAYER_H
#define SMEDIAPLAYER_H

#include <QMediaPlayer>
#include "common/log.h"

class SMediaPlayer : public QMediaPlayer
{
    Q_OBJECT

public:
    explicit SMediaPlayer(QObject *parent = nullptr);

private slots:
    void errorOccured(QMediaPlayer::Error);
    void onDurationChanged(qint64);
    void onMediaStatusChanged(QMediaPlayer::MediaStatus);

signals:
    void eventOccured(const QString&, Log::LogCode);
    void mediaLoaded();

};

#endif // SMEDIAPLAYER_H
