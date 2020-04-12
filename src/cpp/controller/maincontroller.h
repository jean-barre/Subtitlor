#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>

class MainController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int screenWidth READ screenWidth NOTIFY screenWidthChanged)
    Q_PROPERTY(int screenHeight READ screenHeight NOTIFY screenHeightChanged)

public:
    explicit MainController(QObject *parent = nullptr);

    int screenWidth();
    int screenHeight();

    void setScreenWidth(const int);
    void setScreenHeight(const int);

private:
    int q_screenWidth;
    int q_screenHeight;

signals:
    void screenWidthChanged();
    void screenHeightChanged();

};

#endif // MAINCONTROLLER_H
