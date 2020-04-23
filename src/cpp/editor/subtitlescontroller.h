#ifndef SUBTITLESCONTROLLER_H
#define SUBTITLESCONTROLLER_H

#include <QObject>
#include <memory>
#include "subtitle.h"

class SubtitlesController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool onSubtitle READ onSubtitle NOTIFY onSubtitleChanged)

public:
    explicit SubtitlesController(QObject *parent = nullptr);
    ~SubtitlesController();

    bool onSubtitle() const;

    typedef std::shared_ptr<Subtitle> SubtitlePtr;

private:
    std::map<int, SubtitlePtr> subtitles;
    bool q_onSubtitle = false;

    void setOnSubtitle(const bool);

signals:
    void onSubtitleChanged();

public slots:
    void onPlayerPositionChanged(qint64);

};

#endif // SUBTITLESCONTROLLER_H
