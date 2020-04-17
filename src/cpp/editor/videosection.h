#ifndef VIDEOSECTION_H
#define VIDEOSECTION_H

#include <QObject>
#include "smediaplayer.h"

class VideoSection : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SMediaPlayer* mediaObject READ mediaObject CONSTANT)

public:
    explicit VideoSection(QObject *parent = nullptr);
    ~VideoSection();

    SMediaPlayer *mediaObject();

private:
    SMediaPlayer *q_mediaObject = new SMediaPlayer(this);
};

#endif // VIDEOSECTION_H
