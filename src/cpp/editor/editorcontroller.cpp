#include "editorcontroller.h"

EditorController::EditorController(QObject *parent) : QObject(parent)
{
    connect(q_video->mediaObject(), SIGNAL(timeFormatChanged(QString)),
            q_subtitles, SLOT(onTimeFormatChanged(QString)));
    connect(q_video->mediaObject(), SIGNAL(positionChanged(qint64)),
            q_subtitles, SLOT(onPlayerPositionChanged(qint64)));
}

EditorController::~EditorController()
{
    delete q_video;
    delete q_subtitles;
}

VideoSection *EditorController::video()
{
    return q_video;
}

SubtitlesController *EditorController::subtitles()
{
    return q_subtitles;
}
