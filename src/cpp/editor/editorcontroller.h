#ifndef EDITORCONTROLLER_H
#define EDITORCONTROLLER_H

#include <QObject>
#include "videosection.h"
#include "subtitlescontroller.h"

class EditorController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(VideoSection* video READ video CONSTANT)
    Q_PROPERTY(SubtitlesController* subtitles READ subtitles CONSTANT)

public:
    explicit EditorController(QObject *parent = nullptr);
    ~EditorController();

    VideoSection *video();
    SubtitlesController *subtitles();

private:
    VideoSection* q_video = new VideoSection(this);
    SubtitlesController* q_subtitles = new SubtitlesController(this);

};

#endif // EDITORCONTROLLER_H
