#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "src/qmlconnector.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QMLConnector qmlConnector(engine.rootObjects().first()->findChild<QObject*>("stack_view"));

    return app.exec();
}
