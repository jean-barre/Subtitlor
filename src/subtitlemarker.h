#ifndef SUBTITLEMARKER_H
#define SUBTITLEMARKER_H

#include <QString>

class SubtitleMarker
{
public:
    SubtitleMarker();
    SubtitleMarker(int beginTime, int duration, QString text);

    void setBeginTime(int beginTime);
    int getBeginTime();
    void setDuration(int duration);
    int getDuration();
    void setText(QString text);
    QString getText();

private:
    int beginTime;
    int duration;
    QString text;

};

#endif // SUBTITLEMARKER_H
