#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QTimer>

#include "upload/uploadcontroller.h"
#include "editor/editorcontroller.h"
#include "common/log.h"

class MainController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int screenWidth READ screenWidth NOTIFY screenWidthChanged)
    Q_PROPERTY(int screenHeight READ screenHeight NOTIFY screenHeightChanged)
    Q_PROPERTY(QString logMessage READ logMessage NOTIFY logMessageChanged)
    Q_PROPERTY(int logCode READ logCode NOTIFY logCodeChanged)
    Q_PROPERTY(UploadController* upload READ upload NOTIFY uploadChanged)
    Q_PROPERTY(EditorController* editor READ editor CONSTANT)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit MainController(QObject *parent = nullptr);
    ~MainController();

    int screenWidth();
    int screenHeight();
    QString logMessage();
    Log::LogCode logCode();
    UploadController *upload();
    EditorController *editor();
    bool loading() const;

    void setScreenWidth(const int);
    void setScreenHeight(const int);

private:
    int q_screenWidth = 0;
    int q_screenHeight = 0;
    QString q_logMessage = "";
    Log::LogCode q_logCode = Log::LogCode::NORMAL;
    QTimer *logTimer;
    const int LOG_TIMER_DURATION = 5000;

    UploadController* q_uploadController;
    EditorController* q_editorController = new EditorController(this);

    bool q_loading = false;

    void setLogMessage(const QString& message);
    void setLogCode(const Log::LogCode code);
    void setLoading(const bool);

signals:
    void screenWidthChanged();
    void screenHeightChanged();
    void logMessageChanged();
    void logCodeChanged();
    void uploadChanged();
    void performStackPush();
    void loadingChanged();

public slots:
    void triggerStackPush(const QString& currentItemOjectName);
    void log(const QString& message, Log::LogCode code);
    void hideLogMessage();
};

#endif // MAINCONTROLLER_H
