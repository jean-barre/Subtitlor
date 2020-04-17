#ifndef SMEDIAPLAYER_H
#define SMEDIAPLAYER_H

#include <QMediaPlayer>
#include <QVideoRendererControl>

class SMediaPlayer : public QMediaPlayer
{
    Q_OBJECT

public:
    explicit SMediaPlayer(QObject *parent = nullptr);

};

#endif // SMEDIAPLAYER_H
