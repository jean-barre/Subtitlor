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
    text = format_with_zeros(secs, 2) + "." + format_with_zeros(ms, 3)
    text = format_with_zeros(mins, 2) + "." + text
    return text
}

/*
  description: turns an integer time value into a string with extras "0" if needed
  input: int val (time), int number_of_characters (number of characters for this time format)
  output: string text (formatted)
  */
function format_with_zeros(val, number_of_characters) {
    var text = val.toString()
    while(text.length < number_of_characters) {
        text = "0" + text
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
