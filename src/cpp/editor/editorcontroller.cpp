#include "editorcontroller.h"

EditorController::EditorController(QObject *parent) : QObject(parent)
{

}

EditorController::~EditorController()
{
    delete q_video;
}

VideoSection *EditorController::video()
{
    return q_video;
}
