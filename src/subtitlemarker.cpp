#include "subtitlemarker.h"

SubtitleMarker::SubtitleMarker() : beginTime(0), duration(0), text("")
{

}

SubtitleMarker::SubtitleMarker(int beginTime, int duration, QString text) :
    beginTime(beginTime), duration(duration), text(text)
{
}

void SubtitleMarker::setBeginTime(int beginTime)
{
    this->beginTime = beginTime;
}

int SubtitleMarker::getBeginTime()
{
    return this->beginTime;
}

void SubtitleMarker::setDuration(int duration)
{
    this->duration = duration;
}

int SubtitleMarker::getDuration()
{
    return this->duration;
}

void SubtitleMarker::setText(QString text)
{
    this->text = text;
}

QString SubtitleMarker::getText()
{
    return this->text;
}
