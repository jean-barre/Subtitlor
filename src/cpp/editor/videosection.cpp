#include "videosection.h"

VideoSection::VideoSection(QObject *parent) : QObject(parent)
{
}

VideoSection::~VideoSection()
{
    delete q_mediaObject;
}

SMediaPlayer *VideoSection::mediaObject()
{
    return q_mediaObject;
}
