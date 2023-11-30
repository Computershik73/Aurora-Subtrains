.pragma library
.import Sailfish.Silica 1.0 as S

function formatDateWeekday(d) {
    var t = new Date
    var t2 = new Date(d)
    var today = new Date(t.getFullYear(), t.getMonth(), t.getDate())
    var day = new Date(t2.getFullYear(), t2.getMonth(), t2.getDate())

    var tcol = (t.getDay() + 6) % 7
    var t2col = (t2.getDay() + 6) % 7

    var delta = (day - today) / 86400000

    if (delta == 0) {
        //% "Today"
        return "сегодня"
    } else if (delta == -1) {
        //% "Yesterday"
        return "вчера"
    } else if (delta == 1) {
        //% "Tomorrow"
        return "завтра"
    } else if (delta <= -7 || delta >= 7 ||
               (delta < 0 && t2col > tcol) ||
               (delta > 0 && tcol > t2col)) {
        //: Long date pattern without year. Used e.g. in month view.
        //% "d MMMM"
        return Qt.formatDate(d, "d MMMM")
    } else {
        return S.Format.formatDate(d, S.Format.WeekdayNameStandalone)
    }
}

function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.substr(1)
}
