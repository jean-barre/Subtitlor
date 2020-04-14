#include "maincontroller.h"

MainController::MainController(QObject *parent) : QObject(parent),
    q_screenWidth(0), q_screenHeight(0), q_logMessage(""),
    q_logCode(Log::LogCode::NORMAL)
{
    logTimer = new QTimer();
    logTimer->setInterval(LOG_TIMER_DURATION);
    logTimer->setSingleShot(true);
    connect(logTimer, SIGNAL(timeout()), this, SLOT(hideLogMessage()));

    q_uploadController = new UploadController(parent);
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

void MainController::triggerStackPush(const QString& currentItemOjectName)
{
    if (currentItemOjectName.compare("uploadView") == 0)
    {
        if (!q_uploadController->isValid())
        {
            log("It looks like you did not set the files", Log::LogCode::ERROR);
            return;
        }
    }
    emit performStackPush();
}

void MainController::log(const QString& message, Log::LogCode code)
{
    setLogMessage(message);
    setLogCode(code);
    logTimer->start();
}

void MainController::hideLogMessage()
{
    setLogMessage("");
    setLogCode(Log::LogCode::NORMAL);
}
