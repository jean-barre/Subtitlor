#ifndef SRTPARSER_H
#define SRTPARSER_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QTime>

#include "subtitlemarker.h"

class SRTParser
{
public:
    SRTParser(QString, std::map<int, SubtitleMarker*> *);
    ~SRTParser();

private:
    std::map<int, SubtitleMarker*> *subtitles;
    void parse(QTextStream *);
    void parseSubtitle(QTextStream *);
    void storeSubtitle(QStringList &);

};

#endif // SRTPARSER_H
