#include "textstyler.h"

#include <QtGui/QTextDocument>
#include <QtGui/QTextCursor>
#include <QRegularExpression>

#define BOLD_FLAG       1
#define ITALIC_FLAG     2
#define UNDERLINE_FLAG  4
#define COLOR_FLAG      8

TextStyler::TextStyler()
    : m_target(0)
    , m_doc(0)
    , m_cursorPosition(-1)
    , m_selectionStart(0)
    , m_selectionEnd(0)
{
}

void TextStyler::setTarget(QQuickItem *target)
{
    m_doc = 0;
    m_target = target;
    if (!m_target)
        return;

    QVariant doc = m_target->property("textDocument");
    if (doc.canConvert<QQuickTextDocument*>())
    {
        QQuickTextDocument *qqdoc = doc.value<QQuickTextDocument*>();
        if (qqdoc)
        {
            m_doc = qqdoc->textDocument();
        }
    }
    emit targetChanged();
}

void TextStyler::setText(const QString &arg)
{
    if (m_text != arg)
    {
        m_text = arg;
        emit textChanged();
    }
}

QString TextStyler::text() const
{
    return m_text;
}

QString TextStyler::htmlText() const
{
    QString htmlText = "";
    QString htmlDoc = m_doc->toHtml();
    QRegularExpression regExp("(<p [^>]*>)(.+?)(</p>)");
    QRegularExpressionMatch match = regExp.match(htmlDoc);
    if (match.hasMatch())
    {
        htmlText = match.captured(2);
    }
    return htmlSpanToClassicFormat(htmlText);
}

void TextStyler::setCursorPosition(int position)
{
    if (position == m_cursorPosition)
        return;

    m_cursorPosition = position;

    reset();
}

void TextStyler::reset()
{
    emit boldChanged();
    emit italicChanged();
    emit underlineChanged();
    emit textColorChanged();
}

QTextCursor TextStyler::textCursor() const
{
    if (!m_doc)
        return QTextCursor();

    QTextCursor cursor = QTextCursor(m_doc);
    if (m_selectionStart != m_selectionEnd) {
        cursor.setPosition(m_selectionStart);
        cursor.setPosition(m_selectionEnd, QTextCursor::KeepAnchor);
    } else {
        cursor.setPosition(m_cursorPosition);
    }
    return cursor;
}

void TextStyler::mergeFormatOnWordOrSelection(const QTextCharFormat &format)
{
    QTextCursor cursor = textCursor();
    if (!cursor.hasSelection())
        cursor.select(QTextCursor::WordUnderCursor);
    cursor.mergeCharFormat(format);
}

QString TextStyler::htmlSpanToClassicFormat(QString htmlText) const
{
    QString output = "";
    QString color = "";
    unsigned char formatFlags = 0;
    QRegularExpression spanRegExp("(<span [^>]*>)(.+?)(</span>)");
    QRegularExpression colorRegExp("#(\\w)*");
    QRegularExpressionMatch match = spanRegExp.match(htmlText);
    while (match.hasMatch())
    {
        output = htmlText.left(match.capturedStart(1));
        // reset the format flag
        formatFlags = 0;
        QString spanTag = match.captured(1);
        // detect new formats
        if (spanTag.contains("weight"))
        {
            formatFlags |= BOLD_FLAG;
            output += "<b>";
        }
        if (spanTag.contains("italic"))
        {
            formatFlags |= ITALIC_FLAG;
            output += "<i>";
        }
        if (spanTag.contains("underline"))
        {
            formatFlags |= UNDERLINE_FLAG;
            output += "<u>";
        }
        if (spanTag.contains("color"))
        {
            QRegularExpressionMatch colorMatch = colorRegExp.match(htmlText);
            if (colorMatch.hasMatch())
            {
                QString colorCode = colorMatch.captured(0);
                formatFlags |= COLOR_FLAG;
                output += "<font color=\"" + colorCode + "\">";
            }
        }
        output += match.captured(2);
        if ((formatFlags & COLOR_FLAG) == COLOR_FLAG)
        {
            output += "</font>";
        }
        if ((formatFlags & UNDERLINE_FLAG) == UNDERLINE_FLAG)
        {
            output += "</u>";
        }
        if ((formatFlags & ITALIC_FLAG) == ITALIC_FLAG)
        {
            output += "</i>";
        }
        if ((formatFlags & BOLD_FLAG) == BOLD_FLAG)
        {
            output += "</b>";
        }
        int endOffset = match.capturedEnd(3);
        htmlText = output +
            htmlText.right(htmlText.length() - endOffset);
        output = "";
        match = spanRegExp.match(htmlText);
    }
    return factorizeHtml(htmlText);
}

QString TextStyler::factorizeHtml(QString htmlText) const
{
    // Simple level factorization: remove useless tags when they are consecutive
    // TODO: improve the level of factorization:
    // Remove useless tags when they are crossed
    QRegularExpressionMatch match;
    QRegularExpression boldRegExp("</b><b>");
    QRegularExpression italicRegExp("</i><i>");
    QRegularExpression underlineRegExp("</u><u>");
    QList<QRegularExpression> regExpList = {boldRegExp, italicRegExp,
        underlineRegExp};
    for (auto regExp : regExpList)
    {
        while((match = regExp.match(htmlText)).hasMatch())
        {
            int start = match.capturedStart(0);
            int end = match.capturedEnd(0);
            htmlText = htmlText.remove(start, end - start);
        }
    }
    return htmlText;
}

void TextStyler::setSelectionStart(int position)
{
    m_selectionStart = position;
}

void TextStyler::setSelectionEnd(int position)
{
    m_selectionEnd = position;
}

bool TextStyler::bold() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontWeight() == QFont::Bold;
}

bool TextStyler::italic() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontItalic();
}

bool TextStyler::underline() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontUnderline();
}

void TextStyler::setBold(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontWeight(arg ? QFont::Bold : QFont::Normal);
    mergeFormatOnWordOrSelection(fmt);
    emit boldChanged();
}

void TextStyler::setItalic(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontItalic(arg);
    mergeFormatOnWordOrSelection(fmt);
    emit italicChanged();
}

void TextStyler::setUnderline(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontUnderline(arg);
    mergeFormatOnWordOrSelection(fmt);
    emit underlineChanged();
}

QColor TextStyler::textColor() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QColor(Qt::black);
    QTextCharFormat format = cursor.charFormat();
    return format.foreground().color();
}

void TextStyler::setTextColor(const QColor &c)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setForeground(QBrush(c));
    mergeFormatOnWordOrSelection(format);
    emit textColorChanged();
}

