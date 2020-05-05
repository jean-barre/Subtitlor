#include <QQuickView>
#include <QQmlComponent>
#include <QQuickItem>
#include "rangesliderscontroller.h"

/*
 * To do:
 * retrieve previous and next properties to edit it: erase + insert?
 * show a helper on the handles
 */

RangeSlidersController::RangeSlidersController(QObject *parent) : QObject(parent)
{
}

void RangeSlidersController::addRangeSlider(int begin, int duration)
{
    int min = 0;
    int max = videoDuration;
    QQuickItemMapIterator upperIterator = items.upper_bound(begin);
    // find the items after
    if (upperIterator != items.cend()) {
        QQuickItemPtr next = upperIterator->second;
        // make sure it cannot overlap the new range slider
        setRangeSliderFrom(next, begin + duration);
        // compute the new slider's maximum value
        max = getRangeSliderFirstValue(next);
    }
    // find the item before
    if (upperIterator != items.cbegin())
    {
        --upperIterator;
        QQuickItemPtr previous = upperIterator->second;
        // make sure it cannot overlap the new range slider
        setRangeSliderTo(previous, begin);
        // compute the new slider's minimum value
        min = getRangeSliderSecondValue(previous);
    }
    QQuickItem* item = displayRangeSlider(min, max, begin, duration);
    items.insert(std::pair<int, QQuickItemPtr>(begin, QQuickItemPtr(item)));
}

void RangeSlidersController::editRangeSlider(int previousBegin, int newBegin, int duration)
{
    QQuickItemMapIterator iterator = items.find(previousBegin);
    if (!iterator->second)
    {
        return;
    }
    items.erase(iterator);
    addRangeSlider(newBegin, duration);
}

void RangeSlidersController::removeRangeSlider(int begin)
{
    int previousSecondValue = 0;
    int nextFirstValue = videoDuration;
    QQuickItemPtr previous, next;
    QQuickItemMapIterator iterator = items.find(begin);
    QQuickItemPtr item = iterator->second;
    if (!item)
    {
        return;
    }
    items.erase(iterator);
    QQuickItemMapIterator upperIterator = items.upper_bound(begin);
    // find the items after to extend the previous one
    if (upperIterator != items.cend()) {
        next = upperIterator->second;
        nextFirstValue = getRangeSliderFirstValue(next);
    }
    // find the item before to extend the next one
    if (upperIterator != items.cbegin())
    {
        --upperIterator;
        previous = upperIterator->second;
        previousSecondValue = getRangeSliderSecondValue(previous);
    }
    if (previous)
    {
        setRangeSliderTo(previous, nextFirstValue);
    }
    if (next)
    {
        setRangeSliderFrom(next, previousSecondValue);
    }
}

void RangeSlidersController::setParent(QQuickItem *parent)
{
    q_parent = parent;
}

void RangeSlidersController::setVideoDuration(const int duration)
{
    videoDuration = duration;
}

int RangeSlidersController::MsToPixel(const int value) const
{
    return value * SECOND_PIXEL_SIZE / 1000;
}

QQuickItem* RangeSlidersController::displayRangeSlider(const int min, const int max, const int begin, const int duration)
{
    QQmlComponent component(engine, url);
    QObject *object = component.create();
    QQuickItem *item = qobject_cast<QQuickItem*>(object);
    item->setParentItem(q_parent);
    item->setParent(this);
    item->setX(MsToPixel(min));
    item->setWidth(MsToPixel(max - min));
    item->setHeight(item->parentItem()->height());
    item->setProperty("from", min);
    item->setProperty("to", max);
    QMetaObject::invokeMethod(item, "setValues", Q_ARG(double, begin), Q_ARG(double, begin + duration));
    return item;
}

void RangeSlidersController::setRangeSliderFrom(RangeSlidersController::QQuickItemPtr item, const int value)
{
    int nextMax = item->property("to").toInt();
    int firstValue = getRangeSliderFirstValue(item);
    int secondValue = getRangeSliderSecondValue(item);
    item->setX(MsToPixel(value));
    item->setWidth(MsToPixel(nextMax - (value)));
    item->setProperty("from", value);
    QMetaObject::invokeMethod(&*item, "setValues",
                              Q_ARG(double, firstValue),
                              Q_ARG(double, secondValue));
}

void RangeSlidersController::setRangeSliderTo(RangeSlidersController::QQuickItemPtr item, const int value)
{
    int previousMin = item->property("from").toInt();
    int firstValue = getRangeSliderFirstValue(item);
    int secondValue = getRangeSliderSecondValue(item);
    item->setWidth(MsToPixel(value - previousMin));
    item->setProperty("to", value);
    QMetaObject::invokeMethod(&*item, "setValues",
                              Q_ARG(double, firstValue),
                              Q_ARG(double, secondValue));
}

int RangeSlidersController::getRangeSliderFirstValue(RangeSlidersController::QQuickItemPtr item)
{
    QObject *first = item->findChild<QObject*>("first");
    return first->property("value").toInt();
}

int RangeSlidersController::getRangeSliderSecondValue(RangeSlidersController::QQuickItemPtr item)
{
    QObject *second = item->findChild<QObject*>("second");
    return second->property("value").toInt();
}
