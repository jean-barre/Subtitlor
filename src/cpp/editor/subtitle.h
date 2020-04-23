#ifndef SUBTITLEMARKER_H
#define SUBTITLEMARKER_H

#include <QString>

class Subtitle
{
public:
    Subtitle();
    Subtitle(int beginTime, int duration, QString text);

    int beginTime() const;
    int duration() const;
    QString text() const;
    void setBeginTime(const int beginTime);
    void setDuration(const int duration);
    void setText(const QString& text);

private:
    int q_beginTime = 0;
    int q_duration = 0;
    QString q_text = "";

};

#endif // SUBTITLEMARKER_H
