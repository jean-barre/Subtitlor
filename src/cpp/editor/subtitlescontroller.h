#ifndef SUBTITLESCONTROLLER_H
#define SUBTITLESCONTROLLER_H

#include <QObject>
#include <memory>
#include "subtitle.h"

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

private:
    std::map<int, SubtitlePtr> subtitles;
    QString timeFormat = "";
    bool q_onSubtitle = false;
    bool q_editing = false;
    bool q_removing = false;
    SubtitleIterator foundSubtitleIterator;

    QString format(int);
    void setOnSubtitle(const bool);

signals:
    void onSubtitleChanged();
    void editingChanged();
    void removingChanged();

public slots:
    void onTimeFormatChanged(const QString);
    void onPlayerPositionChanged(qint64);

};

#endif // SUBTITLESCONTROLLER_H
