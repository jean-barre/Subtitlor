#include "srteditor.h"

SRTEditor::SRTEditor(QObject *parent) : QObject(parent)
{
    subtitleNumber = 0;
    this->qmlEditorPage = parent->findChild<QObject*>("Edit");
    QObject *qmlPlayer = parent->findChild<QObject*>("media_player");
    QObject::connect(qmlPlayer, SIGNAL(setVideoDuration()), this, SLOT(setVideoDuration()));
    this->qmlEditor = parent->findChild<QObject*>("marker_editor");
    this->subtitles = std::map<int, SubtitleMarker*>();
    QObject::connect(this->qmlEditor, SIGNAL(lookUpIfOnMarker(int)), this, SLOT(find(int)));
    QObject::connect(this->qmlEditor, SIGNAL(addMarker(int, int, QString)), this, SLOT(addSubtitle(int, int, QString)));
    QObject::connect(this->qmlEditor, SIGNAL(editMarker(int, int, QString)), this, SLOT(editSubtitle(int, int, QString)));
    QObject::connect(this->qmlEditor, SIGNAL(removeMarker(int)), this, SLOT(removeSubtitle(int)));
    this->currentItemBeginTime = -1;
}

SRTEditor::~SRTEditor()
{
    for (auto p : this->subtitles) {
        delete p.second;
    }
}

const std::map<int, SubtitleMarker *> &SRTEditor::getSubtitles() const
{
    return this->subtitles;
}

bool SRTEditor::checkSubtitle(int beginTime, int duration, QString text)
{
    bool valid = true;
    if (duration <= 0)
    {
        logMessage(-1, "Addition failure: please set a positive duration");
        valid = false;
    }
    if (text.length() > 100)
    {
        logMessage(-1, "Addition failure: please check the Subtitle text is less than 100 char");
        valid = false;
    }
    return valid;
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
    if ((lowerIterator->first == timeFrame) && (lowerIterator != subtitles.cend()))
    {
        found = true;
        markerFound = static_cast<SubtitleMarker*>(lowerIterator->second);
    }
    else if (lowerIterator != subtitles.cbegin())
    {
        lowerIterator--;
        markerFound = static_cast<SubtitleMarker*>(lowerIterator->second);
        found = markerFound->getBeginTime() + markerFound->getDuration() > timeFrame;
    }
    QMetaObject::invokeMethod(this->qmlEditor, "updateOnMarker",
            Q_ARG(QVariant, found));
    if (found)
    {
        if (markerFound->getBeginTime() != currentItemBeginTime)
        {
            QMetaObject::invokeMethod(this->qmlEditor, "setCurrentMarker",
                    Q_ARG(QVariant, markerFound->getBeginTime()),
                                      Q_ARG(QVariant, markerFound->getDuration()),
                                      Q_ARG(QVariant, markerFound->getText()));
            currentItemBeginTime = markerFound->getBeginTime();
        }
    }
    else
    {
        currentItemBeginTime = -1;
        QMetaObject::invokeMethod(this->qmlEditor, "setCurrentMarker",
                Q_ARG(QVariant, 0), Q_ARG(QVariant, 0), Q_ARG(QVariant, ""));
    }
}

void SRTEditor::addSubtitle(int beginTime, int duration, QString text)
{
    // make sure the input data is correct
    if (!checkSubtitle(beginTime, duration, text))
    {
        return;
    }
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
    subtitleNumber++;
    this->qmlEditor->setProperty("subtitle_number", subtitleNumber);
    logMessage(1, "Addition success");
}

void SRTEditor::editSubtitle(int beginTime, int duration, QString text)
{
    // make sure the input data is correct
    if (!checkSubtitle(beginTime, duration, text))
    {
        return;
    }
    SubtitleMarker *markerFound = new SubtitleMarker();
    auto lowerIterator = this->subtitles.lower_bound(beginTime);
    if (lowerIterator->first == beginTime)
    {
        markerFound = static_cast<SubtitleMarker*>(lowerIterator->second);
        markerFound->setDuration(duration);
        markerFound->setText(text);
        logMessage(1, "Edition success");
    }
    else
    {
        logMessage(-1, "Edition failure");
    }
}

void SRTEditor::removeSubtitle(int beginTime)
{
    auto lowerIterator = this->subtitles.lower_bound(beginTime);
    if (lowerIterator->first == beginTime)
    {
        this->subtitles.erase(lowerIterator);
        subtitleNumber--;
        this->qmlEditor->setProperty("subtitle_number", subtitleNumber);
        logMessage(1, "Removal success");
    }
    else
    {
        logMessage(-1, "Removal failure");
    }
}
