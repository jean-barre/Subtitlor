#include "maincontroller.h"

MainController::MainController(QObject *parent) : QObject(parent),
    q_screenWidth(0), q_screenHeight(0)
{

}

int MainController::screenWidth()
{
    return q_screenWidth;
}

int MainController::screenHeight()
{
    return q_screenHeight;
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
