#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QScreen>
#include <QQmlContext>
#include <QQuickStyle>
#include <QFont>

#include "maincontroller.h"
#include "editor/smediaplayer.h"
#include "editor/textstyler.h"
#include "editor/timeinputcontroller.h"
#include "theme.h"
#include "log.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QGuiApplication::setOrganizationName("Jean BARRE");
    QGuiApplication::setOrganizationDomain("fr.jeanbarre");
    QGuiApplication::setApplicationName("Subtitlor");

    MainController mainController;
    QRect screenGeometry = QGuiApplication::primaryScreen()->geometry();
    mainController.setScreenWidth(screenGeometry.width());
    mainController.setScreenHeight(screenGeometry.height());

    QQuickStyle::setStyle("Material");
    QFont font(Theme::getInstance().fontFamily());
    font.setStyleName(Theme::getInstance().fontStyleName());
    font.setPointSize(Theme::getInstance().fontPointSize());
    QGuiApplication::setFont(font);

    qmlRegisterSingletonType<Theme>("com.subtitlor.theme", 1, 0, "Theme", Theme::themeSingletonTypeProvider);
    qmlRegisterUncreatableMetaObject(Log::staticMetaObject, "com.subtitlor.log", 1, 0, "Log", "Log namespace");
    qmlRegisterType<TextStyler>("com.subtitlor.editor", 1, 0, "TextStyler");
    qmlRegisterType<TimeInputController>("com.subtitlor.editor", 1, 0, "TimeInputController");

    engine.rootContext()->setContextProperty("mainController", &mainController);
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}
