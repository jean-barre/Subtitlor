#ifndef THEME_H
#define THEME_H

#include <QObject>
#include <QtQml>

class Theme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fontFamily READ fontFamily NOTIFY fontFamilyChanged)
    Q_PROPERTY(QString fontStyleName READ fontStyleName NOTIFY fontStyleNameChanged)
    Q_PROPERTY(int fontSmallPointSize READ fontSmallPointSize NOTIFY fontSmallPointSizeChanged)
    Q_PROPERTY(int fontPointSize READ fontPointSize NOTIFY fontPointSizeChanged)
    Q_PROPERTY(int fontLargePointSize READ fontLargePointSize NOTIFY fontLargePointSizeChanged)
    Q_PROPERTY(QString primaryColor READ primaryColor NOTIFY primaryColorChanged)
    Q_PROPERTY(QString accentColor READ accentColor NOTIFY accentColorChanged)
    Q_PROPERTY(QString foregroundColor READ foregroundColor NOTIFY foregroundColorChanged)
    Q_PROPERTY(QString backgroundColor READ backgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(QString successColor READ successColor NOTIFY successColorChanged)
    Q_PROPERTY(QString errorColor READ errorColor NOTIFY errorColorChanged)
    Q_PROPERTY(int margin READ margin NOTIFY marginChanged)

private:
    QString q_fontFamily;
    QString q_fontStyleName;
    int q_fontSmallPointSize;
    int q_fontPointSize;
    int q_fontLargePointSize;
    QString q_primaryColor;
    QString q_accentColor;
    QString q_foregroundColor;
    QString q_backgroundColor;
    QString q_successColor;
    QString q_errorColor;
    int q_margin;

public:
    explicit Theme(QObject *parent = nullptr);
    static Theme& getInstance();
    static QObject* themeSingletonTypeProvider(QQmlEngine*, QJSEngine*);

    Theme(Theme const&)   			= delete;
    void operator=(Theme const&)	= delete;

    QString fontFamily() const;
    QString fontStyleName() const;
    int fontSmallPointSize() const;
    int fontPointSize() const;
    int fontLargePointSize() const;
    QString primaryColor() const;
    QString accentColor() const;
    QString foregroundColor() const;
    QString backgroundColor() const;
    QString successColor() const;
    QString errorColor() const;
    int margin() const;

signals:
    void fontFamilyChanged();
    void fontStyleNameChanged();
    void fontSmallPointSizeChanged();
    void fontPointSizeChanged();
    void fontLargePointSizeChanged();
    void primaryColorChanged();
    void accentColorChanged();
    void foregroundColorChanged();
    void backgroundColorChanged();
    void successColorChanged();
    void errorColorChanged();
    void marginChanged();
};

#endif // THEME_H
