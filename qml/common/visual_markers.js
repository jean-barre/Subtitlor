var markers = []
var sliderRoot

function setSliderRoot(root) {
    sliderRoot = root
}

function addMarker(root, secondPixelSize, minPosition, maxPosition, begin, end) {
    var previousMarker, nextMarker;
    // find previous and next markers
    previousMarker = findMarkerByBeginValue(minPosition);
    nextMarker = findMarkerByBeginValue(maxPosition)

    if (previousMarker) {
        minPosition += (previousMarker.second.value - previousMarker.first.value)
    }
    // create the active marker
    createMarker(root, secondPixelSize, minPosition, maxPosition, begin, end);

    // copy the previous marker updated regarding to active one's values
    // and remove the old one
    if (previousMarker) {
        // edit to and width values
        createMarker(root, secondPixelSize, previousMarker.from, begin, previousMarker.first.value, previousMarker.second.value);
        previousMarker.destroy();
    }
    // copy the next marker updated regarding to active one's values
    // and remove the old one
    if (nextMarker) {
        createMarker(root, secondPixelSize, end, nextMarker.to, nextMarker.first.value, nextMarker.second.value);
        nextMarker.destroy();
    }
}

function editMarker(root, secondPixelSize, minPosition, maxPosition, begin, end) {
    var previousMarker, activeMarker, nextMarker;
    // find previous and next markers
    previousMarker = findMarkerByBeginValue(minPosition);
    activeMarker = findMarkerByBeginValue(begin);
    nextMarker = findMarkerByBeginValue(maxPosition);

    if (previousMarker) {
        minPosition += (previousMarker.second.value - previousMarker.first.value)
    }
    // create the active marker
    createMarker(root, secondPixelSize, minPosition, maxPosition, begin, end);

    // copy the previous marker updated regarding to active one's values
    // and remove the old one
    if (previousMarker) {
        // edit to and width values
        createMarker(root, secondPixelSize, previousMarker.from, begin, previousMarker.first.value, previousMarker.second.value);
        previousMarker.destroy();
    }
    // copy the next marker updated regarding to active one's values
    // and remove the old one
    if (nextMarker) {
        createMarker(root, secondPixelSize, end, nextMarker.to, nextMarker.first.value, nextMarker.second.value);
        nextMarker.destroy();
    }
}

function findMarkerByBeginValue(beginValue) {
    var returnMarker;
    for (var i=0; i<markers.length; i++) {
        var marker = markers[i];
        if (marker.first.value === beginValue) {
            returnMarker = marker;
        }
    }
    return returnMarker;
}

function createMarker(root, secondPixelSize, minPosition, maxPosition, begin, end) {
    // add the new marker
    var component = Qt.createComponent("TimeRangeSlider.qml");
    var sprite = component.createObject(root, {
                                            "x": secondPixelSize * minPosition / 1000,
                                            "y": root.height * 3,
                                            "width": secondPixelSize * (maxPosition - minPosition) / 1000,
                                            "height": root.height / 2,
                                            "from": minPosition,
                                            "to": maxPosition,
                                            "first.value": begin,
                                            "second.value": end,
                                            "root": sliderRoot
                                        });
    if (sprite === null) {
        // Error Handling
        console.log("Error creating object");
    }
    markers.push(sprite)
}

function removeMarker(root, secondPixelSize, begin) {
    var new_markers = []
    var marker_x = secondPixelSize * begin / 1000
    for (var i=0; i<markers.length; i++) {
        var marker = markers[i]
        if (marker.x !== marker_x) {
            new_markers.push(marker)
        } else {
            marker.destroy()
        }
    }
    markers = new_markers
}
