#include "theme.h"

Theme::Theme(QObject *parent) : QObject(parent), q_fontFamily("Open Sans"),
    q_fontStyleName("Normal"), q_fontSmallPointSize(9), q_fontPointSize(11),
    q_fontLargePointSize(13), q_primaryColor("#121212"), q_accentColor("#90CAF9"),
    q_foregroundColor("#FFFFFF"), q_backgroundColor("#121212"),
    q_successColor("#A5D6A7"), q_errorColor("#EF9A9A"), q_margin(20)
{
}

Theme &Theme::getInstance()
{
    static Theme instance;
    return instance;
}

QObject *Theme::themeSingletonTypeProvider(QQmlEngine*, QJSEngine*)
{
    return new Theme();
}

QString Theme::fontFamily() const
{
    return q_fontFamily;
}

QString Theme::fontStyleName() const
{
    return q_fontStyleName;
}

int Theme::fontSmallPointSize() const
{
    return q_fontSmallPointSize;
}

int Theme::fontPointSize() const
{
    return q_fontPointSize;
}

int Theme::fontLargePointSize() const
{
    return q_fontLargePointSize;
}

QString Theme::primaryColor() const
{
    return q_primaryColor;
}

QString Theme::accentColor() const
{
    return q_accentColor;
}

QString Theme::foregroundColor() const
{
    return q_foregroundColor;
}

QString Theme::backgroundColor() const
{
    return q_backgroundColor;
}

QString Theme::successColor() const
{
    return q_successColor;
}

QString Theme::errorColor() const
{
    return q_errorColor;
}

int Theme::margin() const
{
    return q_margin;
}
