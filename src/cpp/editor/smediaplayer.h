#ifndef SMEDIAPLAYER_H
#define SMEDIAPLAYER_H

#include <QMediaPlayer>
#include "common/log.h"

class SMediaPlayer : public QMediaPlayer
{
    Q_OBJECT
    // duplicate the duration property to be updated after the time format
    Q_PROPERTY(int sduration READ sduration NOTIFY sdurationChanged)
    Q_PROPERTY(QString timeFormat READ timeFormat NOTIFY timeFormatChanged)
    Q_PROPERTY(QString formattedPosition READ formattedPosition NOTIFY formattedPositionChanged)
    Q_PROPERTY(QString formattedDuration READ formattedDuration NOTIFY formattedDurationChanged)

public:
    explicit SMediaPlayer(QObject *parent = nullptr);

    int sduration() const;
    QString timeFormat() const;
    QString formattedPosition() const;
    QString formattedDuration() const;

    Q_INVOKABLE QString format(int);

private:
    const int MINUT_IN_MS = 60000;
    const int HOUR_IN_MS = 3600000;
    const QString MINUTS_TIME_FORMAT = "mm.ss.zzz";
    const QString SECONDS_TIME_FORMAT = "ss.zzz";

    int q_sduration = 0;
    QString q_timeFormat = MINUTS_TIME_FORMAT;
    QString q_formattedPosition = "";
    QString q_formattedDuration = "";

    void updateSduration();
    void setTimeFormat(const QString&);
    void setFormattedPosition(const QString&);
    void setFormattedDuration(const QString&);

private slots:
    void errorOccured(QMediaPlayer::Error);
    void onDurationChanged(qint64);
    void onPositionChanged(qint64);
    void onMediaStatusChanged(QMediaPlayer::MediaStatus);

signals:
    void eventOccured(const QString&, Log::LogCode);
    void mediaLoaded();
    void sdurationChanged();
    void timeFormatChanged(const QString);
    void formattedPositionChanged();
    void formattedDurationChanged();

};

#endif // SMEDIAPLAYER_H
