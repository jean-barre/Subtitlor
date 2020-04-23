#include "subtitle.h"

Subtitle::Subtitle()
{
}

Subtitle::Subtitle(int beginTime, int duration, QString text) :
    q_beginTime(beginTime), q_duration(duration), q_text(text)
{
}

int Subtitle::beginTime() const
{
    return q_beginTime;
}

int Subtitle::duration() const
{
    return q_duration;
}

QString Subtitle::text() const
{
    return q_text;
}

void Subtitle::setBeginTime(const int beginTime)
{
    if (beginTime != q_beginTime)
    {
        q_beginTime = beginTime;
    }
}

void Subtitle::setDuration(const int duration)
{
    if (duration != q_duration)
    {
        q_duration = duration;
    }
}

void Subtitle::setText(const QString& text)
{
    if (text != q_text)
    {
        q_text = text;
    }
}
