import QtQuick 2.0
import Sailfish.Silica 1.0
import aurora.subtrains.positioning 1.0
import aurora.subtrains.searchHint 1.0
import aurora.subtrains.qmlHandler 1.0

Page {
    id: page
    property QmlHandler qmlHandler

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: true
    }

    Connections {
        target: qmlHandler
        //onRouteModelChanged: {
            //if qmlHandler.routeModel.
        //}
        onThreadsListRecieved: {
            busyIndicator.running = false;
            viewPlaceholder.text =
                    qsTr("Не нашлось подходящих маршрутов :(");
        }
        onErrorRecievingThreads: {
            busyIndicator.running = false;
            viewPlaceholder.text =
                    qsTr("Что-то пошло не так. " +
                    "Пожалуйста, проверьте, что у вас включена " +
                    "передача данных " +
                    "и попробуйте снова");
        }
    }

    SilicaListView {
        id: listView
        model: qmlHandler.routeModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Маршруты по направлению")
        }

        ViewPlaceholder {
            id: viewPlaceholder
            enabled: listView.count == 0 && !busyIndicator.running
            text: ""
        }

        delegate: ListItem {
            id: delegate
            contentHeight: Theme.itemSizeLarge

            Column {
                id: leftColumn
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }

                Label {
                    id: departureTime
                    anchors.horizontalCenter: leftColumn.horizontalCenter
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    text: modelData.departure.time.substring(11,16)
                }
                Label {
                    id: arrivalTime
                    anchors.horizontalCenter: leftColumn.horizontalCenter
                    font.pixelSize: Theme.fontSizeMedium
                    text: modelData.arrival.time.substring(11,16)
                }
            }

            Label {
                id: centerLabel
                anchors {
                    left: leftColumn.right
                    leftMargin: Theme.paddingMedium
                    right: rightColumn.left
                    rightMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                text: modelData.thread.title
            }

            Column {
                id: rightColumn
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }

                Label {
                    id: duration
                    text: modelData.duration + qsTr(" мин.")
                }

            }
            onClicked: {
                qmlHandler.getTrainInfo(modelData.thread.uid, new Date(modelData.departure.time));
                pageStack.push(Qt.resolvedUrl("ThreadInfo.qml"), {qmlHandler: qmlHandler});
            }
        }
        VerticalScrollDecorator{}
    }
}

