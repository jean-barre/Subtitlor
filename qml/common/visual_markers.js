var markers = []

function addMarker(root, begin, duration) {
    var component = Qt.createComponent("SliderMark.qml");
    var sprite = component.createObject(root, {
                                            "x": Math.round(begin / root.maximumValue * root.width * 1000) / 1000,
                                            "y": root.height * 0.25,
                                            "z": -1,
                                            "width": duration / root.maximumValue * root.width,
                                            "height": root.height * 0.5
                                        });
    if (sprite === null) {
        // Error Handling
        console.log("Error creating object");
    }
    markers.push(sprite)
}

function removeMarker(root, begin) {
    var new_markers = []
    var marker_x = Math.round(begin / root.maximumValue * root.width * 1000) / 1000
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