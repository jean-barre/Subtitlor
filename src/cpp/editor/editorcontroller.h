#ifndef EDITORCONTROLLER_H
#define EDITORCONTROLLER_H

#include <QObject>
#include "videosection.h"

class EditorController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(VideoSection* video READ video CONSTANT)

public:
    explicit EditorController(QObject *parent = nullptr);
    ~EditorController();

    VideoSection *video();

private:
    VideoSection* q_video = new VideoSection(this);

};

#endif // EDITORCONTROLLER_H
