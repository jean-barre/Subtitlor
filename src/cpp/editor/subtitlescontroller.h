#ifndef SUBTITLESCONTROLLER_H
#define SUBTITLESCONTROLLER_H

#include <QObject>
#include <memory>
#include "subtitle.h"
#include "common/log.h"

class SubtitlesController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool onSubtitle READ onSubtitle NOTIFY onSubtitleChanged)
    Q_PROPERTY(bool editing READ editing WRITE setEditing NOTIFY editingChanged)
    Q_PROPERTY(bool removing READ removing WRITE setRemoving NOTIFY removingChanged)

public:
    explicit SubtitlesController(QObject *parent = nullptr);
    ~SubtitlesController();

    bool onSubtitle() const;

    typedef std::shared_ptr<Subtitle> SubtitlePtr;
    typedef std::map<int, SubtitlePtr>::iterator SubtitleIterator;

    bool editing() const;
    bool removing() const;

    void setEditing(const bool);
    void setRemoving(const bool);

    Q_INVOKABLE QString getFoundBeginTime();
    Q_INVOKABLE QString getFoundDuration();
    Q_INVOKABLE QString getFoundText();

    Q_INVOKABLE void editFound(const QString, const QString, const QString);
    Q_INVOKABLE void add(const QString, const QString, const QString);

private:
    std::map<int, SubtitlePtr> subtitles;
    QString timeFormat = "";
    int playerPosition = 0;
    int playerDuration = 0;
    bool q_onSubtitle = false;
    bool q_editing = false;
    bool q_removing = false;
    SubtitleIterator foundSubtitleIterator;

    QString format(int);
    int unformat(const QString) const;
    void synchronize();
    void setOnSubtitle(const bool);
    bool addSubtitle(const int, const int, const QString);

signals:
    void onSubtitleChanged();
    void log(const QString, Log::LogCode);
    void editingChanged();
    void removingChanged();

public slots:
    void onTimeFormatChanged(const QString);
    void onPlayerPositionChanged(qint64);
    void onPlayerDurationChanged(qint64);

};

#endif // SUBTITLESCONTROLLER_H
