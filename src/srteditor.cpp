#include "srteditor.h"

SRTEditor::SRTEditor(QObject *parent) : QObject(parent)
{
    subtitleNumber = 0;
    this->qmlEditorPage = parent->findChild<QObject*>("Edit");
    QObject *qmlPlayer = parent->findChild<QObject*>("media_player");
    QObject::connect(qmlPlayer, SIGNAL(setVideoDuration()), this, SLOT(setVideoDuration()));
    this->qmlController = parent->findChild<QObject*>("media_controller");
    this->qmlVideoViewer = parent->findChild<QObject*>("video_viewer");
    this->qmlEditor = parent->findChild<QObject*>("marker_editor");
    this->subtitles = std::map<int, SubtitleMarker*>();

    QString srtFileUrl = QQmlProperty::read(this->qmlEditorPage, "srt_url").toString();
    SRTParser(srtFileUrl, &this->subtitles);

    QObject::connect(this->qmlEditor, SIGNAL(lookUpIfOnMarker(int)), this, SLOT(find(int)));
    QObject::connect(this->qmlEditor, SIGNAL(addSubtitle(int, int, QString)), this, SLOT(addSubtitle(int, int, QString)));
    QObject::connect(this->qmlEditor, SIGNAL(editSubtitle(int, int, int, QString)), this, SLOT(editSubtitle(int, int, int, QString)));
    QObject::connect(this->qmlEditor, SIGNAL(removeSubtitle(int)), this, SLOT(removeSubtitle(int)));

    QObject::connect(this->qmlController, SIGNAL(editSubtitleTiming(int, int, int)), this, SLOT(editSubtitleTiming(int, int, int)));
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

// This method is called once: when the video duration slot is called
void SRTEditor::setUploadedSubtitles()
{
    SubtitleMarker *marker, *previousMarker, *twoPreviousMarker;
    int subtitleNumber = 0;
    int min, max, begin, end;
    if (this->subtitles.size() == 0)
    {
        return;
    }
    for (auto p : this->subtitles)
    {
        subtitleNumber++;
        marker = p.second;

        if (!previousMarker)
        {
            break;
        }
        // add the first marker
        if (!twoPreviousMarker)
        {
            min = 0;
        }
        else
        {
            min = twoPreviousMarker->getBeginTime() + twoPreviousMarker->getDuration();
        }
        max = marker->getBeginTime();
        begin = previousMarker->getBeginTime();
        end = begin + previousMarker->getDuration();
        QMetaObject::invokeMethod(this->qmlController, "addMarker",
                                  Q_ARG(QVariant, min), Q_ARG(QVariant, max),
                                  Q_ARG(QVariant, begin), Q_ARG(QVariant, end));
        twoPreviousMarker = previousMarker;
        previousMarker = marker;
    }
    // add the last marker
    min = previousMarker? previousMarker->getBeginTime() + previousMarker->getDuration() : 0;
    max = this->videoDuration;
    begin = marker->getBeginTime();
    end = marker->getBeginTime() + marker->getDuration();
    QMetaObject::invokeMethod(this->qmlController, "addMarker",
                              Q_ARG(QVariant, min), Q_ARG(QVariant, max),
                              Q_ARG(QVariant, begin), Q_ARG(QVariant, end));

    this->qmlEditor->setProperty("subtitle_number", subtitleNumber);
    this->subtitleNumber = subtitleNumber;
    logMessage(1, "Upload success");
}

bool SRTEditor::checkSubtitle(int beginTime, int duration, QString text)
{
    bool valid = true;
    if (beginTime < 0)
    {
        logMessage(-1, "Operation failure: please set a positive begining time");
        valid = false;
    }
    if (duration <= 0)
    {
        logMessage(-1, "Operation failure: please set a positive duration");
        valid = false;
    }
    if (text.length() > 100)
    {
        logMessage(-1, "Operation failure: please check the Subtitle text is less than 100 char");
        valid = false;
    }
    return valid;
}

bool SRTEditor::checkSubtitleForAddition(int beginTime, int duration)
{
    // make sure there is no overlap with a previous marker
    auto it = this->subtitles.lower_bound(beginTime);
    if (it != this->subtitles.begin())
    {
        it--;
        int previousMarkerEndTime = it->first + it->second->getDuration();
        if (beginTime < previousMarkerEndTime)
        {
            logMessage(-1, "Addition failure: overlapping with a previous item");
            return false;
        }
    }
    // make sure there is no overlap with a next marker
    auto higherIterator = this->subtitles.upper_bound(beginTime);
    if (higherIterator != this->subtitles.cend())
    {
        SubtitleMarker *next = higherIterator->second;
        if (beginTime + duration > next->getBeginTime())
        {
            logMessage(-1, "Addition failure: overlapping an item after");
            return false;
        }
    }
    // or the end of the video
    else
    {
        if (beginTime + duration > this->videoDuration)
        {
            logMessage(-1, "Addition failure: overlapping with the end of the video");
            return false;
        }
    }
    return true;
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
    // Make sure the controller gets the information
    // before any marker can be set
    QMetaObject::invokeMethod(this->qmlController, "setVideoDuration",
            Q_ARG(QVariant, this->videoDuration));
    if (this->subtitles.size() > 0) {
        setUploadedSubtitles();
    }
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
            QMetaObject::invokeMethod(this->qmlVideoViewer, "setVisualSubtitle", Q_ARG(QVariant, markerFound->getText()));
            currentItemBeginTime = markerFound->getBeginTime();
        }
    }
    else
    {
        currentItemBeginTime = -1;
        QMetaObject::invokeMethod(this->qmlEditor, "setCurrentMarker",
                Q_ARG(QVariant, 0), Q_ARG(QVariant, 1000), Q_ARG(QVariant, ""));
        QMetaObject::invokeMethod(this->qmlVideoViewer, "setVisualSubtitle", Q_ARG(QVariant, ""));
    }
}

void SRTEditor::addSubtitle(int beginTime, int duration, QString text)
{
    // make sure the input data is correct
    if (!checkSubtitle(beginTime, duration, text) || !checkSubtitleForAddition(beginTime, duration))
    {
        return;
    }
    SubtitleMarker *marker = new SubtitleMarker(beginTime, duration, text);
    std::pair<std::map<int, SubtitleMarker*>::iterator, bool> returnValue = this->subtitles.insert(std::pair<int,SubtitleMarker*>(beginTime, marker));

    auto it = returnValue.first;
    int previousMarkerBeginTime = -1, previousMarkerEndTime = -1, nextMarkerBeginTime = -1;
    // look for a previous marker
    if (it != this->subtitles.begin())
    {
        it--;
        previousMarkerBeginTime = it->first;
        previousMarkerEndTime = it->first + it->second->getDuration();
        QMetaObject::invokeMethod(this->qmlController, "editMarkerMax",
                                  Q_ARG(QVariant, previousMarkerBeginTime), Q_ARG(QVariant, beginTime));
    }
    // look for a next marker
    it = returnValue.first;
    if (it != this->subtitles.end())
    {
        it++;
        if (it != this->subtitles.end())
        {
            nextMarkerBeginTime = it->first;
            QMetaObject::invokeMethod(this->qmlController, "editMarkerMin",
                                      Q_ARG(QVariant, nextMarkerBeginTime), Q_ARG(QVariant, beginTime + duration));
        }
    }
    // set the default values if previous or next subtitles are not found
    if (previousMarkerEndTime == -1)
    {
        previousMarkerEndTime = 0;
    }
    if (nextMarkerBeginTime == -1)
    {
        nextMarkerBeginTime = this->videoDuration;
    }
    QMetaObject::invokeMethod(this->qmlController, "addMarker",
                              Q_ARG(QVariant, previousMarkerEndTime), Q_ARG(QVariant, nextMarkerBeginTime),
                              Q_ARG(QVariant, beginTime), Q_ARG(QVariant, beginTime + duration));
    subtitleNumber++;
    this->qmlEditor->setProperty("subtitle_number", subtitleNumber);
    logMessage(1, "Addition success");
}

void SRTEditor::editSubtitle(int previousBeginTime, int beginTime, int duration, QString text, bool fromController)
{
    SubtitleMarker* marker;
    int previousMarkerBeginTime = -1, previousMarkerEndTime = -1, nextMarkerBeginTime = -1;
    // make sure the input data is correct
    if (!checkSubtitle(beginTime, duration, text))
    {
        return;
    }
    auto markerFound = this->subtitles.lower_bound(previousBeginTime);
    if (markerFound->first != previousBeginTime)
    {
        logMessage(-1, "Edition failure, subtitle not found");
        return;
    }
    marker = markerFound->second;
    marker->setBeginTime(beginTime);
    marker->setDuration(duration);
    marker->setText(text);
    // look for a previous marker
    auto it = markerFound;
    if (it != this->subtitles.begin())
    {
        it--;
        previousMarkerBeginTime = it->first;
        previousMarkerEndTime = it->first + it->second->getDuration();
        QMetaObject::invokeMethod(this->qmlController, "editMarkerMax",
                                  Q_ARG(QVariant, previousMarkerBeginTime),
                                  Q_ARG(QVariant, beginTime));
    }
    // look for a next marker
    it = markerFound;
    if (it != this->subtitles.end())
    {
        it++;
        if (it != this->subtitles.end())
        {
            nextMarkerBeginTime = it->first;
            QMetaObject::invokeMethod(this->qmlController, "editMarkerMin",
                                      Q_ARG(QVariant, nextMarkerBeginTime),
                                      Q_ARG(QVariant, beginTime + duration));
        }
    }
    // set the default values if previous or next subtitles are not found
    if (previousMarkerEndTime == -1)
    {
        previousMarkerEndTime = 0;
    }
    if (nextMarkerBeginTime == -1)
    {
        nextMarkerBeginTime = this->videoDuration;
    }
    // edit the marker in the map
    this->subtitles.erase(markerFound);
    std::pair<std::map<int, SubtitleMarker*>::iterator, bool> returnValue = this->subtitles.insert(std::pair<int,SubtitleMarker*>(beginTime, marker));
    if (!returnValue.second)
    {
        logMessage(-1, "Edition failure, map insertion failed");
        return;
    }
    if (!fromController)
    {
        // update the marker in the timeline
        QMetaObject::invokeMethod(this->qmlController, "editMarker",
                      Q_ARG(QVariant, previousMarkerEndTime),
                      Q_ARG(QVariant, nextMarkerBeginTime),
                      Q_ARG(QVariant, previousBeginTime),
                      Q_ARG(QVariant, beginTime),
                      Q_ARG(QVariant, beginTime + duration));
    }
    logMessage(1, "Edition success");
}

void SRTEditor::editSubtitleTiming(int previousBeginTime, int beginTime, int end)
{
    // find the corresponding subtitle
    auto it = this->subtitles.lower_bound(previousBeginTime);
    if (it->first != previousBeginTime)
    {
        logMessage(-1, "Edition failure, subtitle not found");
        return;
    }
    // compute the new duration
    int duration = end - beginTime;
    // retrieve its text
    QString text = it->second->getText();
    editSubtitle(previousBeginTime, beginTime, duration, text, true);
}

void SRTEditor::removeSubtitle(int beginTime)
{
    int previousMarkerBeginTime = -1, previousMarkerEndTime = -1, nextMarkerBeginTime = -1;
    auto markerFound = this->subtitles.lower_bound(beginTime);
    if (markerFound->first != beginTime)
    {
        logMessage(-1, "Removal failure");
        return;
    }
    // look for a previous marker
    auto it = markerFound;
    if (it != this->subtitles.begin())
    {
        it--;
        previousMarkerBeginTime = it->first;
        previousMarkerEndTime = it->first + it->second->getDuration();
    }
    // look for a next marker
    it = markerFound;
    if (it != this->subtitles.end())
    {
        it++;
        if (it != this->subtitles.end())
        {
            nextMarkerBeginTime = it->first;
        }
    }
    // set the default values if previous or next subtitles are not found
    if (previousMarkerBeginTime == -1)
    {
        previousMarkerEndTime = 0;
    }
    if (nextMarkerBeginTime == -1)
    {
        nextMarkerBeginTime = this->videoDuration;
    }
    else
    {
        QMetaObject::invokeMethod(this->qmlController, "editMarkerMin",
                                  Q_ARG(QVariant, nextMarkerBeginTime),
                                  Q_ARG(QVariant, previousMarkerEndTime));
    }
    if (previousMarkerBeginTime != -1)
    {
        QMetaObject::invokeMethod(this->qmlController, "editMarkerMax",
                                  Q_ARG(QVariant, previousMarkerBeginTime),
                                  Q_ARG(QVariant, nextMarkerBeginTime));
    }

    this->subtitles.erase(markerFound);
    QMetaObject::invokeMethod(this->qmlController, "removeMarker", Q_ARG(QVariant, beginTime));
    subtitleNumber--;
    this->qmlEditor->setProperty("subtitle_number", subtitleNumber);
    logMessage(1, "Removal success");
    // update the interface
    find(beginTime);
}
