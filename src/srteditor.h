#ifndef SRCEDITOR_H
#define SRCEDITOR_H

#include <QObject>
#include <QDebug>
#include <QQmlProperty>
#include <QTime>

#include "subtitlemarker.h"
#include "srtparser.h"

class SRTEditor : public QObject
{
    Q_OBJECT
public:
    explicit SRTEditor(QObject *parent = nullptr);
    void initialize();
    ~SRTEditor();
    const std::map<int, SubtitleMarker*>& getSubtitles() const;

private:
    QObject *parent;
    int subtitleNumber;
    int videoDuration;
    QObject *qmlEditorPage;
    QObject *qmlEditor;
    QObject *qmlController;
    QObject *qmlVideoViewer;
    std::map<int, SubtitleMarker*> subtitles;
    int currentItemBeginTime;
    void setUploadedSubtitles();
    bool checkSubtitle(int beginTime, int duration, QString text);
    bool checkSubtitleForAddition(int beginTime, int duration);
    void logMessage(int code, QString error); // code value: [-1, error], [0, info], [1, valid]

signals:
    void updateUIAfterFind(bool found);

public slots:
    void setVideoDuration();
    void find(int timeFrame);
    void addSubtitle(int beginTime, int duration, QString text);
    void editSubtitle(int previousBeginTime, int beginTime, int duration, QString text, bool fromController = false);
    void editSubtitleTiming(int previousBeginTime, int beginTime, int end);
    void removeSubtitle(int beginTime);

};

#endif // SRCEDITOR_H
