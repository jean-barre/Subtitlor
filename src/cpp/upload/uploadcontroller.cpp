#include "uploadcontroller.h"

UploadController::UploadController(QObject *parent) : QObject(parent),
    q_editionUseCase(false)
{
    q_videoFile = new File(parent, File::FileType::VIDEO);
    q_srtFile = new File(parent, File::FileType::SRT);
}

bool UploadController::editionUseCase()
{
    return q_editionUseCase;
}

File *UploadController::videoFile()
{
    return q_videoFile;
}

File *UploadController::srtFile()
{
    return q_srtFile;
}

void UploadController::setEditionUseCase(bool editionUseCase)
{
    if (editionUseCase != q_editionUseCase)
    {
        q_editionUseCase = editionUseCase;
        emit editionUseCaseChanged();
    }
}

bool UploadController::isValid()
{
    if (q_editionUseCase)
    {
        return q_videoFile->isValid() && q_srtFile->isValid();
    }
    return q_videoFile->isValid();
}
