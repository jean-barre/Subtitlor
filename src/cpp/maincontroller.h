#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>

#include "upload/uploadcontroller.h"

class MainController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int screenWidth READ screenWidth NOTIFY screenWidthChanged)
    Q_PROPERTY(int screenHeight READ screenHeight NOTIFY screenHeightChanged)
    Q_PROPERTY(UploadController* upload READ upload NOTIFY uploadChanged)

public:
    explicit MainController(QObject *parent = nullptr);

    int screenWidth();
    int screenHeight();
    UploadController *upload();

    void setScreenWidth(const int);
    void setScreenHeight(const int);

private:
    int q_screenWidth;
    int q_screenHeight;
    UploadController* q_uploadController;

signals:
    void screenWidthChanged();
    void screenHeightChanged();
    void uploadChanged();
    void performStackPush();

public slots:
    void triggerStackPush(const QString& currentItemOjectName);
};

#endif // MAINCONTROLLER_H
