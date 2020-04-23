#ifndef TIMEINPUTCONTROLLER_H
#define TIMEINPUTCONTROLLER_H

#include <QObject>

class TimeInputController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString format READ text WRITE setFormat)
    Q_PROPERTY(bool isValid READ isValid NOTIFY isValidChanged)

public:
    explicit TimeInputController(QObject *parent = nullptr);

    QString text() const;
    QString format() const;
    bool isValid() const;

    void setText(const QString&);
    void setFormat(const QString&);

private:
    QString q_text = "";
    QString q_format = "mm.ss.zzz";
    bool q_isValid = true;

    void setIsValid(const bool);

private slots:
    void onTextChanged();

signals:
    void textChanged();
    void isValidChanged();

};

#endif // TIMEINPUTCONTROLLER_H
