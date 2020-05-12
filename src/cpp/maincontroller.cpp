#include "maincontroller.h"

void MainController::stackViewItemChanged(QString viewName)
{
    if (viewName.compare("Editor"))
    {
        q_editorController->subtitles()->initializeRangeSliders();
    }
}

MainController::MainController(QObject *parent) : QObject(parent)
{
    logTimer = new QTimer();
    logTimer->setInterval(LOG_TIMER_DURATION);
    logTimer->setSingleShot(true);
    connect(logTimer, SIGNAL(timeout()), this, SLOT(hideLogMessage()));

    q_uploadController = new UploadController(parent);

    connect(q_editorController->video()->mediaObject(), SIGNAL(eventOccured(const QString&, Log::LogCode)),
            this, SLOT(log(const QString&, Log::LogCode)));
    connect(q_editorController->video()->mediaObject(), SIGNAL(mediaLoaded()),
            this, SLOT(onMediaLoaded()));
    connect(q_editorController->subtitles(), SIGNAL(log(const QString&, Log::LogCode)),
            this, SLOT(log(const QString&, Log::LogCode)));

    connect(this, SIGNAL(presetExportFields(const bool, const QString)),
            q_exportController, SLOT(presetFields(const bool, const QString)));
    connect(q_exportController, SIGNAL(processExport(const QString)),
            q_editorController->subtitles(), SLOT(saveToFile(const QString)));
}

MainController::~MainController()
{
    delete logTimer;
    delete q_uploadController;
    delete q_editorController;
    delete q_exportController;
}

int MainController::screenWidth()
{
    return q_screenWidth;
}

int MainController::screenHeight()
{
    return q_screenHeight;
}

QString MainController::logMessage()
{
    return q_logMessage;
}

Log::LogCode MainController::logCode()
{
    return q_logCode;
}

UploadController *MainController::upload()
{
    return q_uploadController;
}

EditorController *MainController::editor()
{
    return q_editorController;
}

ExportController *MainController::srtExport()
{
    return q_exportController;
}

bool MainController::loading() const
{
    return q_loading;
}

void MainController::setScreenWidth(const int width)
{
    if (width != q_screenWidth)
    {
        q_screenWidth = width;
        emit screenWidthChanged();
    }
}

void MainController::setScreenHeight(const int height)
{
    if (height != q_screenHeight)
    {
        q_screenHeight = height;
        emit screenHeightChanged();
    }
}

void MainController::setLogMessage(const QString& message)
{
    if (message != q_logMessage)
    {
        q_logMessage = message;
        emit logMessageChanged();
    }
}

void MainController::setLogCode(const Log::LogCode code)
{
    if (code != q_logCode)
    {
        q_logCode = code;
        emit logCodeChanged();
    }
}

void MainController::setLoading(const bool loading)
{
    if (loading != q_loading)
    {
        q_loading = loading;
        emit loadingChanged();
    }
}

void MainController::triggerStackPush(const QString& currentItemOjectName)
{
    if (currentItemOjectName.compare("uploadView") == 0)
    {
        if (!q_uploadController->isValid())
        {
            log("It looks like you did not set the files", Log::LogCode::ERROR);
            return;
        }
        else
        {
            q_editorController->video()->mediaObject()->setMedia(QUrl(q_uploadController->videoFile()->fileURL()));
            if (q_uploadController->editionUseCase())
            {
                srtParsingSuccess = q_editorController->subtitles()->parseSRTFile(q_uploadController->srtFile()->fileURL());
            }
            setLoading(true);
        }
        return;
    }
    emit performStackPush();
}

void MainController::log(const QString& message, Log::LogCode code)
{
    setLoading(false);
    setLogMessage(message);
    setLogCode(code);
    logTimer->start();
}

void MainController::hideLogMessage()
{
    setLogMessage("");
    setLogCode(Log::LogCode::NORMAL);
}

void MainController::onMediaLoaded()
{
    if (q_loading)
    {
        setLoading(false);
        if (q_uploadController->editionUseCase() && !srtParsingSuccess)
        {
            return;
        }
        emit performStackPush();
        // preset fields of the Export view
        // using the subtitles file url if using an existing one
        if (q_uploadController->editionUseCase())
        {
            emit presetExportFields(q_uploadController->editionUseCase(),
                                    q_uploadController->srtFile()->fileURL());
        }
        // using the video file url otherwise
        else
        {
            emit presetExportFields(q_uploadController->editionUseCase(),
                                    q_uploadController->videoFile()->fileURL());
        }
    }
}
