#include "maincontroller.h"

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
}

MainController::~MainController()
{
    delete logTimer;
    delete q_uploadController;
    delete q_editorController;
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
        emit performStackPush();
    }
}
