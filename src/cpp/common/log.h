#ifndef LOG_H
#define LOG_H

#include <QObject>

namespace Log {

    Q_NAMESPACE

    enum LogCode {
        NORMAL,
        ERROR,
        SUCCESS
    };
    Q_ENUM_NS(LogCode)
}

#endif // LOG_H
