#ifndef SRCEDITOR_H
#define SRCEDITOR_H

#include <QObject>
#include "subtitlemarker.h"
#include <QDebug>
#include <QQmlProperty>
#include <QTime>

class SRTEditor : public QObject
{
    Q_OBJECT
public:
    explicit SRTEditor(QObject *parent = nullptr);
    ~SRTEditor();

private:
    int videoDuration;
    QObject *qmlEditorPage;
    QObject *qmlEditor;
    std::map<int, SubtitleMarker*> subtitles;
    int currentItemBeginTime;
    void logMessage(int code, QString error); // code value: [-1, error], [0, info], [1, valid]

signals:
    void updateUIAfterFind(bool found);

public slots:
    void setVideoDuration();
    void find(int timeFrame);
    void addSubtitle(int beginTime, int duration, QString text);

};

#endif // SRCEDITOR_H
