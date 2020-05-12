#ifndef RANGESLIDERSCONTROLLER_H
#define RANGESLIDERSCONTROLLER_H

#include <memory>
#include <QObject>
#include <QQuickItem>
#include <QQmlEngine>

class RangeSlidersController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem* parent WRITE setParent)

public:
    explicit RangeSlidersController(QObject *parent = nullptr);

    void addRangeSlider(int begin, int duration);
    void editRangeSlider(int previousBegin, int newBegin, int duration);
    void removeRangeSlider(int begin);
    void clear();

    void setParent(QQuickItem *);
    void setVideoDuration(const int);

private:
    const int SECOND_PIXEL_SIZE = 200;

    typedef std::shared_ptr<QQuickItem> QQuickItemPtr;
    typedef std::map<int, QQuickItemPtr>::iterator QQuickItemMapIterator;

    QQmlEngine *engine = new QQmlEngine;
    QUrl url = QUrl(QStringLiteral("qrc:/qml/editor/timeline/RangeSlider.qml"));
    QQuickItem *q_parent = nullptr;
    std::map<int, QQuickItemPtr> items;
    int videoDuration = 0;

    int MsToPixel(const int) const;
    QQuickItem* displayRangeSlider(const int min, const int max, const int begin,
                            const int duration);
    void setRangeSliderFrom(QQuickItemPtr item, const int);
    void setRangeSliderTo(QQuickItemPtr item, const int);
    int getRangeSliderFirstValue(QQuickItemPtr item);
    int getRangeSliderSecondValue(QQuickItemPtr item);

signals:
    void timingChanged(const int previousBegin, const int newBegin, const int duration);

public slots:
    void onRangeSliderFirstValueChanged(const int);
    void onRangeSliderSecondValueChanged(const int);
};

#endif // RANGESLIDERSCONTROLLER_H
