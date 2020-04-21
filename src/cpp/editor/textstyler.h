#ifndef TEXTSTYLER_H
#define TEXTSTYLER_H

#include <QQuickTextDocument>

#include <QtGui/QTextCharFormat>
#include <QtCore/QTextCodec>

#include <qqmlfile.h>

QT_BEGIN_NAMESPACE
class QTextDocument;
QT_END_NAMESPACE

class TextStyler : public QObject
{
    Q_OBJECT

    Q_ENUMS(HAlignment)

    Q_PROPERTY(QQuickItem *target READ target WRITE setTarget NOTIFY targetChanged)
    Q_PROPERTY(QString htmlText READ htmlText)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int selectionStart READ selectionStart WRITE setSelectionStart NOTIFY selectionStartChanged)
    Q_PROPERTY(int selectionEnd READ selectionEnd WRITE setSelectionEnd NOTIFY selectionEndChanged)

    Q_PROPERTY(QColor textColor READ textColor WRITE setTextColor NOTIFY textColorChanged)
    Q_PROPERTY(bool bold READ bold WRITE setBold NOTIFY boldChanged)
    Q_PROPERTY(bool italic READ italic WRITE setItalic NOTIFY italicChanged)
    Q_PROPERTY(bool underline READ underline WRITE setUnderline NOTIFY underlineChanged)

public:
    TextStyler();

    QQuickItem *target() { return m_target; }
    QString htmlText() const;

    void setTarget(QQuickItem *target);

    void setCursorPosition(int position);
    void setSelectionStart(int position);
    void setSelectionEnd(int position);

    int cursorPosition() const { return m_cursorPosition; }
    int selectionStart() const { return m_selectionStart; }
    int selectionEnd() const { return m_selectionEnd; }

    QColor textColor() const;
    QString text() const;
    bool bold() const;
    bool italic() const;
    bool underline() const;

public Q_SLOTS:
    void setText(const QString &arg);
    void setBold(bool arg);
    void setItalic(bool arg);
    void setUnderline(bool arg);
    void setTextColor(const QColor &arg);

Q_SIGNALS:
    void targetChanged();
    void cursorPositionChanged();
    void selectionStartChanged();
    void selectionEndChanged();

    void textColorChanged();
    void boldChanged();
    void italicChanged();
    void underlineChanged();

    void textChanged();

private:
    void reset();
    QTextCursor textCursor() const;
    void mergeFormatOnWordOrSelection(const QTextCharFormat &format);
    QString htmlSpanToClassicFormat(QString htmlText) const;
    QString factorizeHtml(QString htmlText) const;

    QQuickItem *m_target;
    QTextDocument *m_doc;

    int m_cursorPosition;
    int m_selectionStart;
    int m_selectionEnd;

    QString m_text;
};

#endif
