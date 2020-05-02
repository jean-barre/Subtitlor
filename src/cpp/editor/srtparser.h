#ifndef SRTPARSER_H
#define SRTPARSER_H

#include <QObject>
#include <QTextStream>
#include <memory>
#include "subtitle.h"
#include "log.h"

class SRTParser : public QObject
{
    Q_OBJECT

public:
    typedef std::shared_ptr<Subtitle> SubtitlePtr;

    SRTParser(QString ,std::map<int, SubtitlePtr> * );
    bool parse();
    int subtitlesCount = 0;

private:
    QString fileURL;
    std::map<int, SubtitlePtr> *subtitles;
    int lineCount = 0;

    bool parseSubtitle(QTextStream&);
    bool parseSubtitleContent(QStringList&);

Q_SIGNALS:
    void log(const QString, Log::LogCode);
    void parsed(bool);

};

#endif // SRTPARSER_H
