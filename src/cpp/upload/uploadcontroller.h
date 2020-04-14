#ifndef UPLOADCONTROLLER_H
#define UPLOADCONTROLLER_H

#include <QObject>

#include "file.h"

class UploadController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool editionUseCase READ editionUseCase WRITE setEditionUseCase NOTIFY editionUseCaseChanged)
    Q_PROPERTY(File* videoFile READ videoFile NOTIFY videoFileChanged)
    Q_PROPERTY(File* srtFile READ srtFile NOTIFY srtFileChanged)

public:
    explicit UploadController(QObject *parent = nullptr);

    bool editionUseCase();
    File *videoFile();
    File *srtFile();

    void setEditionUseCase(bool);
    bool isValid();

private:
    bool q_editionUseCase;
    File* q_videoFile;
    File* q_srtFile;

signals:
    void editionUseCaseChanged();
    void videoFileChanged();
    void srtFileChanged();

};

#endif // UPLOADCONTROLLER_H
