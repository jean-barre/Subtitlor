var markers = []
var squareSlider
var squareSliderTimeline
var sliderSecondPixelSize

function setSquareSlider(object) {
    squareSlider = object
}

function setSquareSliderTimeline(object) {
    squareSliderTimeline = object
}

function setSecondPixelSize(secondPixelSize) {
    sliderSecondPixelSize = secondPixelSize
}

function findMarkerByBeginValue(beginValue) {
    var returnMarker;
    for (var i=0; i<markers.length; i++) {
        var marker = markers[i];
        if (marker.first.value === beginValue) {
            returnMarker = marker;
        }
    }
    if (!returnMarker) {
        console.log("Marker not found")
    }
    return returnMarker;
}

function addMarker(min, max, begin, end) {
    // add the new marker
    var component = Qt.createComponent("TimeRangeSlider.qml");
    var sprite = component.createObject(squareSliderTimeline, {
                                            "x": sliderSecondPixelSize * min / 1000,
                                            "y": squareSliderTimeline.height * 3,
                                            "width": sliderSecondPixelSize * (max - min) / 1000,
                                            "height": squareSliderTimeline.height / 2,
                                            "from": min,
                                            "to": max,
                                            "first.value": begin,
                                            "second.value": end,
                                            "root": squareSlider
                                        });
    if (sprite === null) {
        // Error Handling
        console.log("Error creating object");
    }
    // add the marker to the global list
    markers.push(sprite)
}

function editMarker(min, max, previousBegin, begin, end) {
    var marker = findMarkerByBeginValue(previousBegin)
    if (marker) {
        removeMarker(previousBegin)
        addMarker(min, max, begin, end)
    }
}

function editMarkerMin(begin, min) {
    var marker = findMarkerByBeginValue(begin)
    if (marker) {
        var max = marker.to
        var end = marker.second.value
        removeMarker(begin)
        addMarker(min, max, begin, end)
    }
}

function editMarkerMax(begin, max) {
    var marker = findMarkerByBeginValue(begin)
    if (marker)
    {
        var min = marker.from
        var end = marker.second.value
        removeMarker(begin)
        addMarker(min, max, begin, end)
    }
}

function removeMarker(begin) {
    var newMarkers = []
    var markerToRemove = findMarkerByBeginValue(begin)
    if (!markerToRemove) {
        return
    }
    // remove the marker from the global list
    for (var i=0; i<markers.length; i++) {
        if (markers[i] !== markerToRemove) {
            newMarkers.push(markers[i])
        }
    }
    markers = newMarkers
    markerToRemove.destroy()
}
