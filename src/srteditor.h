#ifndef SRCEDITOR_H
#define SRCEDITOR_H

#include <QObject>
#include "subtitlemarker.h"
#include <QDebug>

class SRTEditor : public QObject
{
    Q_OBJECT
public:
    explicit SRTEditor(QObject *parent = nullptr);
    ~SRTEditor();

private:
    int videoDuration;
    QObject *qmlEditor;
    std::map<int, SubtitleMarker*> subtitles;
    int currentItemBeginTime;

signals:
    void updateUIAfterFind(bool found);

public slots:
    void setVideoDuration();
    void find(int timeFrame);
    void addSubtitle(int beginTime, int duration, QString text);

};

#endif // SRCEDITOR_H
