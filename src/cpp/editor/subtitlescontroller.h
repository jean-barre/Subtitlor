#ifndef SUBTITLESCONTROLLER_H
#define SUBTITLESCONTROLLER_H

#include <QObject>
#include <memory>
#include "subtitle.h"
#include "common/log.h"
#include "rangesliderscontroller.h"

class SubtitlesController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int subtitleCount READ subtitleCount NOTIFY subtitleCountChanged)
    Q_PROPERTY(bool onSubtitle READ onSubtitle NOTIFY onSubtitleChanged)
    Q_PROPERTY(bool editing READ editing WRITE setEditing NOTIFY editingChanged)
    Q_PROPERTY(bool removing READ removing WRITE setRemoving NOTIFY removingChanged)
    Q_PROPERTY(QString currentSubtitleText READ currentSubtitleText NOTIFY currentSubtitleTextChanged)
    Q_PROPERTY(QString temporaryFileURL READ temporaryFileURL CONSTANT)
    Q_PROPERTY(bool temporarySavingEnabled READ temporarySavingEnabled CONSTANT)
    Q_PROPERTY(RangeSlidersController* rangeSliders READ rangeSliders CONSTANT)

public:
    explicit SubtitlesController(QObject *parent = nullptr);
    ~SubtitlesController();

    int subtitleCount() const;
    bool onSubtitle() const;

    typedef std::shared_ptr<Subtitle> SubtitlePtr;
    typedef std::map<int, SubtitlePtr>::iterator SubtitleIterator;

    bool editing() const;
    bool removing() const;
    QString currentSubtitleText() const;
    QString temporaryFileURL() const;
    bool temporarySavingEnabled() const;
    RangeSlidersController *rangeSliders();

    void setSubtitleCount(const int);
    void setEditing(const bool);
    void setRemoving(const bool);

    Q_INVOKABLE QString getFoundBeginTime();
    Q_INVOKABLE QString getFoundDuration();
    Q_INVOKABLE QString getFoundText();

    Q_INVOKABLE void editFound(const QString, const QString, const QString);
    Q_INVOKABLE void removeFound();
    Q_INVOKABLE void add(const QString, const QString, const QString);

    int parseSRTFile(const QString fileURL);
    void initializeRangeSliders();

private:
    const QString SRT_TIME_FORMAT = "hh:mm:ss,zzz";
    static const QString TEMP_EXPORT_FILE;
    bool q_temporarySavingEnabled = false;
    std::map<int, SubtitlePtr> subtitles;
    QString timeFormat = "";
    int playerPosition = 0;
    int playerDuration = 0;
    int q_subtitleCount = 0;
    bool q_onSubtitle = false;
    bool q_editing = false;
    bool q_removing = false;
    QString q_currentSubtitleText = "";
    SubtitleIterator foundSubtitleIterator;
    RangeSlidersController *q_rangeSliders = new RangeSlidersController(this);

    QString format(int);
    int unformat(const QString) const;
    void synchronize();
    void setOnSubtitle(const bool);
    void setCurrentSubtitleText(const QString);
    bool addSubtitle(const int, const int, const QString);

signals:
    void subtitleCountChanged();
    void onSubtitleChanged();
    void log(const QString, Log::LogCode);
    void editingChanged();
    void removingChanged();
    void currentSubtitleTextChanged();

public slots:
    void onTimeFormatChanged(const QString);
    void onPlayerPositionChanged(qint64);
    void onPlayerDurationChanged(qint64);
    void saveToFile(const QString fileURL = TEMP_EXPORT_FILE);
    void onTimingChanged(const int previousBegin, const int begin, const int duration);
};

#endif // SUBTITLESCONTROLLER_H
