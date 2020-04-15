#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QTimer>

#include "upload/uploadcontroller.h"
#include "common/log.h"

class MainController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int screenWidth READ screenWidth NOTIFY screenWidthChanged)
    Q_PROPERTY(int screenHeight READ screenHeight NOTIFY screenHeightChanged)
    Q_PROPERTY(QString logMessage READ logMessage NOTIFY logMessageChanged)
    Q_PROPERTY(int logCode READ logCode NOTIFY logCodeChanged)
    Q_PROPERTY(UploadController* upload READ upload NOTIFY uploadChanged)

public:
    explicit MainController(QObject *parent = nullptr);
    ~MainController();

    int screenWidth();
    int screenHeight();
    QString logMessage();
    Log::LogCode logCode();
    UploadController *upload();

    void setScreenWidth(const int);
    void setScreenHeight(const int);

private:
    int q_screenWidth;
    int q_screenHeight;
    QString q_logMessage;
    Log::LogCode q_logCode;
    QTimer *logTimer;
    const int LOG_TIMER_DURATION = 5000;

    UploadController* q_uploadController;

    void setLogMessage(const QString& message);
    void setLogCode(const Log::LogCode code);

signals:
    void screenWidthChanged();
    void screenHeightChanged();
    void logMessageChanged();
    void logCodeChanged();
    void uploadChanged();
    void performStackPush();

public slots:
    void triggerStackPush(const QString& currentItemOjectName);
    void log(const QString& message, Log::LogCode code);
    void hideLogMessage();
};

#endif // MAINCONTROLLER_H
