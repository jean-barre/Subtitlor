#include <QTime>
#include "timeinputcontroller.h"

TimeInputController::TimeInputController(QObject *parent) : QObject(parent)
{
    connect(this, SIGNAL(textChanged()), this, SLOT(onTextChanged()));
}

QString TimeInputController::text() const
{
    return q_text;
}

QString TimeInputController::format() const
{
    return q_format;
}

bool TimeInputController::isValid() const
{
    return q_isValid;
}

void TimeInputController::setText(const QString& text)
{
    if (text != q_text)
    {
        q_text = text;
        emit textChanged();
    }
}

void TimeInputController::setFormat(const QString& format)
{
    if (format != q_format)
    {
        q_format = format;
    }
}

void TimeInputController::setIsValid(const bool isValid)
{
    if (isValid != q_isValid)
    {
        q_isValid = isValid;
        emit isValidChanged();
    }
}

void TimeInputController::onTextChanged()
{
    QTime time = QTime::fromString(q_text, q_format);
    setIsValid(time.isValid());
}
