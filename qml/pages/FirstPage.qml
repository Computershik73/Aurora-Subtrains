import QtQuick 2.0
import Sailfish.Silica 1.0
import aurora.subtrains.positioning 1.0
import aurora.subtrains.searchHint 1.0
import aurora.subtrains.qmlHandler 1.0
import "../views"
import "Util.js" as Util

Page {
    id: page
    property int zoneId: 1
    onZoneIdChanged: {
        searchFrom.zoneId = zoneId
        searchTo.zoneId = zoneId
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        VerticalScrollDecorator {}

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {

            MenuItem{
                text: qsTr("О программе")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                text: qsTr("Сменить пригородную зону")
                onClicked: { var dialog = pageStack.push(Qt.resolvedUrl("ZonePage.qml"), {qmlHandler: qmlHandler});
                    dialog.accepted.connect(function(id, text) {
                        page.zoneId = id;
                        currentZone.value = text;
                    })
                }
            }
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.

        Positioning {
            id: posRequest

            onCurrentZoneReady: {
                page.zoneId = posRequest.currentZone.code
                currentZone.value = posRequest.currentZone.title
            }
        }

        Column {
            id: column

            anchors.fill: parent
            spacing: Theme.paddingMedium

            // ЗАГОЛОВОК

            PageHeader {
                title: qsTr("Расписание электричек")
                id: pageHeader
            }

            DetailItem {
                id: currentZone
                label: qsTr("Регион")
                value: qsTr("Москва и область")
            }

            // ДАТА

            BackgroundItem {
                id: button
                width: parent.width
                height: Theme.itemSizeMedium
                onClicked: {
                    var currentDate = new Date();
                    var dateForCalendar = dateLabel.areSelectedAndCurrentDateEqual() === true ?
                                currentDate :
                                dateLabel.selectedDate;
                    var dialog = pageStack.push(pickerComponent, {
                                                    date: dateForCalendar
                                                })
                    dialog.accepted.connect(function() {
                        dateLabel.selectedDate = dialog.date;
                        dateLabel.text = Util.formatDateWeekday(dialog.date);
                        var isEarlierDate = false;
                        //set time part to all zeroes to compare only the part of date without time.
                        currentDate.setHours(0,0,0,0);
                        dialog.date.setHours(0,0,0,0);
                        if (dialog.date < currentDate) {
                            isEarlierDate = true;
                        }
                        badDate.visible = isEarlierDate;
                    })
                }

                Label {
                    id: dateLabel
                    anchors {
                        right: moreImage.left
                        rightMargin: Theme.paddingMedium
                        verticalCenter: parent.verticalCenter
                    }
                    property var selectedDate: {return null}
                    property var areSelectedAndCurrentDateEqual:
                        function() {
                            var currentDate = new Date();
                            if (dateLabel.selectedDate.getDate() !== currentDate.getDate() ||
                                    dateLabel.selectedDate.getMonth() !== currentDate.getMonth() ||
                                    dateLabel.selectedDate.getFullYear() !== currentDate.getFullYear()) {
                                return false;
                            }
                            return true;
                        }

                    text: {
                        var currentDate = new Date();
                        dateLabel.selectedDate = currentDate;
                        return Util.formatDateWeekday(currentDate)
                    }
                    color: button.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeLarge
                }

                Image {
                    id: moreImage
                    anchors {
                        right: parent.right
                        rightMargin: Theme.paddingMedium * 2
                        verticalCenter: parent.verticalCenter
                    }
                    source: "image://theme/icon-m-right?" + (button.highlighted ? Theme.highlightColor
                                                                                : Theme.primaryColor)
                }

                Component {
                    id: pickerComponent
                    DatePickerDialog {}
                }
            }

            // ПЛОХАЯ ДАТА

            SectionHeader {
                id: badDate
                visible: false
                text: qsTr("Выбрана прошедшая дата")
            }

            // ОТКУДА

            SearchBox {
                id: searchFrom
                zoneId: page.zoneId
                placeHolderText: qsTr("Откуда")
                onChangeFocus: {
                    pageHeader.visible = !focusState;
                    currentZone.visible = !focusState;
                    button.visible = !focusState;
                    // Handle badDate somehow
                    searchTo.visible = !focusState;
                }
                width: parent.width
            }

            // КУДА

            SearchBox {
                id: searchTo
                zoneId: page.zoneId
                placeHolderText: qsTr("Куда")
                onChangeFocus: {
                    pageHeader.visible = !focusState;
                    currentZone.visible = !focusState;
                    button.visible = !focusState;
                    // Handle badDate somehow
                    searchFrom.visible = !focusState;
                }
                width: parent.width

            }

            // КНОПКА ПОИСКА
            Row {
                spacing: page.width/20
                width: page.width
                Button {
                    id: swapButton
                    text: qsTr("<->")
                    width: page.width/4
                    // anchors.leftMargin: page.width/20
                    onClicked: {
                        /*var tt = searchFrom.stationEsr;
                        searchFrom.stationEsr = searchTo.stationEsr;
                        searchTo.stationEsr = tt;*/
                        var stationFromEsr = searchFrom.stationEsr;
                        var stationToEsr = searchTo.stationEsr;

                        var t = searchFrom.text;
                        searchFrom.text = searchTo.text;
                        searchFrom.hints.model.clear();
                        searchTo.text = t;

                        searchTo.hints.model.clear();

                        qmlHandler.getRoute(stationToEsr, stationFromEsr, searchTo.is__meta, searchFrom.is__meta, dateLabel.selectedDate);
                        pageStack.push(Qt.resolvedUrl("ThreadsPage.qml"), {qmlHandler: qmlHandler});
                    }
                }

                Button {
                    id: searchButton
                    text: qsTr("Поиск")
                    onClicked: {
                        qmlHandler.getRoute(searchFrom.stationEsr, searchTo.stationEsr, searchFrom.is__meta, searchTo.is__meta, dateLabel.selectedDate);
                        pageStack.push(Qt.resolvedUrl("ThreadsPage.qml"), {qmlHandler: qmlHandler});
                    }
                }

                Button {
                    id: warnButton
                    text: qsTr("!!!")
                    color: qmlHandler.alerttext != "" ? "white" : "grey"
                    width: page.width/4
                    onClicked: {

                    }
                }
            }
        }
    }
}


