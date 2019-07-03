/*
  description: turns an integer of milliseconds into a string in the formats "ss.mss", "mm:ss.mss" or "HH:mm:ss.mss"
  input: int s (milliseconds)
  output: string text (formatted)
  */
function format(s) {
    var text = ""
    var ms = s % 1000;
    s = (s - ms) / 1000;
    var secs = s % 60;
    s = (s - secs) / 60;
    var mins = s % 60;
    var hrs = (s - mins) / 60;
    text = format_with_zeros(secs, 1) + "." + format_with_zeros(ms, 2)
    if (mins > 0) {
        text = format_with_zeros(mins, 1) + ":" + text
        if (hrs > 0) {
            text = format_with_zeros(hrs, 1) + ":" + text
        }
    }
    return text
}

/*
  description: turns an integer time value into a string with an extra "0" if the value is lower than 9
  input: int val (time), int zeros (numer of zero needed)
  output: string text (formatted)
  */
function format_with_zeros(val, zeros) {
    var text = val
    if (val <= 9) {
        for (var i=0; i<zeros; i++) {
            text = "0" + text
        }
    }
    return text
}

/*
  description: turns a string in the formats "ss.mss", "mm:ss.mss" or "HH:mm:ss.mss" into an integer of milliseconds
  input: string text (formatted)
  output: int s (milliseconds)
  */
function unformat(text) {
    var mins = 0, hrs = 0
    var texts = text.split(':')
    // get seconds and milliseconds
    var sms = texts[texts.length - 1]
    var smstexts = sms.split('.')
    var s = smstexts[0]
    var ms = smstexts[1]
    // get minutes
    if (texts.length === 2) {
        mins = texts[0]
    } else if (texts.length === 3) {
        mins = texts[1]
        hrs = texts[0]
    }
    return parseInt(hrs) * 360000 + parseInt(mins) * 60000 + parseInt(s) * 1000 + parseInt(ms)
}
