#include "srteditor.h"

SRTEditor::SRTEditor(QObject *parent) : QObject(parent)
{
    this->qmlEditorPage = parent->findChild<QObject*>("Edit");

    QObject *qmlPlayer = parent->findChild<QObject*>("media_player");
    QObject::connect(qmlPlayer, SIGNAL(setVideoDuration()), this, SLOT(setVideoDuration()));
    this->qmlEditor = parent->findChild<QObject*>("marker_editor");
    this->subtitles = std::map<int, SubtitleMarker*>();
    QObject::connect(this->qmlEditor, SIGNAL(lookUpIfOnMarker(int)), this, SLOT(find(int)));
    QObject::connect(this->qmlEditor, SIGNAL(addMarker(int, int, QString)), this, SLOT(addSubtitle(int, int, QString)));

    this->currentItemBeginTime = -1;

    int sampleTimeFrame = 3000;
    SubtitleMarker *sampleMarker = new SubtitleMarker(sampleTimeFrame, 2000, "hello");
    this->subtitles.insert(std::pair<int, SubtitleMarker*>(sampleTimeFrame, sampleMarker));
}

SRTEditor::~SRTEditor()
{
    for (auto p : this->subtitles) {
        delete p.second;
    }
}

void SRTEditor::logMessage(int code, QString error)
{
    QString time = QTime::currentTime().toString("HH:mm");
    QMetaObject::invokeMethod(qmlEditorPage, "displayLogMessage",
            Q_ARG(QVariant, code), Q_ARG(QVariant, time), Q_ARG(QVariant, error));
}

void SRTEditor::setVideoDuration()
{
    QObject *qmlPlayer = this->parent()->findChild<QObject*>("media_player");
    this->videoDuration = qmlPlayer->property("duration").toInt();
}

void SRTEditor::find(int timeFrame)
// returns true if a subtitle is set during the timeFrame parameter
{
    bool found = false;
    SubtitleMarker *markerFound = new SubtitleMarker();
    auto lowerIterator = this->subtitles.lower_bound(timeFrame);
    if ((lowerIterator->first == timeFrame) && (lowerIterator != subtitles.cend())) {
        found = true;
        markerFound = static_cast<SubtitleMarker*>(lowerIterator->second);
    } else if (lowerIterator != subtitles.cbegin()) {
        lowerIterator--;
        markerFound = static_cast<SubtitleMarker*>(lowerIterator->second);
        found = markerFound->getBeginTime() + markerFound->getDuration() > timeFrame;
    }
    QMetaObject::invokeMethod(this->qmlEditor, "updateOnMarker",
            Q_ARG(QVariant, found));
    if (found) {
        if (markerFound->getBeginTime() != currentItemBeginTime) {
            QMetaObject::invokeMethod(this->qmlEditor, "setCurrentMarker",
                    Q_ARG(QVariant, markerFound->getBeginTime()),
                                      Q_ARG(QVariant, markerFound->getDuration()),
                                      Q_ARG(QVariant, markerFound->getText()));
            currentItemBeginTime = markerFound->getBeginTime();
        }
    } else {
        currentItemBeginTime = -1;
        QMetaObject::invokeMethod(this->qmlEditor, "setCurrentMarker",
                Q_ARG(QVariant, 0), Q_ARG(QVariant, 0), Q_ARG(QVariant, ""));
    }
}

void SRTEditor::addSubtitle(int beginTime, int duration, QString text)
{
    // make sur there is no overlap with a next marker
    auto higherIterator = this->subtitles.upper_bound(beginTime);
    if (higherIterator != this->subtitles.cend())
    {
        SubtitleMarker *next = higherIterator->second;
        if (beginTime + duration > next->getBeginTime())
        {
            logMessage(-1, "Addition failure: overlapping an item after");
            return;
        }
    }
    // or the end of the video
    else
    {
        if (beginTime + duration > this->videoDuration)
        {
            logMessage(-1, "Addition failure: overlapping with the end of the video");
            return;
        }
    }
    SubtitleMarker *marker = new SubtitleMarker(beginTime, duration, text);
    this->subtitles.insert(std::pair<int,SubtitleMarker*>(beginTime, marker));
}
