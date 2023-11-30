import QtQuick 2.0
import Sailfish.Silica 1.0
import aurora.subtrains.positioning 1.0
import aurora.subtrains.searchHint 1.0
import aurora.subtrains.qmlHandler 1.0

Page {
    id: zoneDialog
    signal accepted(int id, string text)
    property QmlHandler qmlHandler

    property var timeZoneId: {return null}

    function getZonesLike(text) {
         return qmlHandler.getZonesLike(text);
    }

    function getAllZones() {
         return qmlHandler.getAllZones();
    }

    SilicaListView {
        id: listView

        anchors.fill: parent

        header: Column {
            width: listView.width
            spacing: 0

            property alias searchField: searchField

            // Заголовок
            PageHeader {
                title: qsTr("Регионы")
            }
            SearchField {
                id: searchField

                width: parent.width
                placeholderText: qsTr("Поиск")

                onTextChanged: {
                    listModel.update()
                }
            }
        }

        model: ListModel {
            id: listModel

            function update() {
                clear()

                var searchField = listView.headerItem.searchField
                var results = getZonesLike(searchField.text);
                for (var i in results) {
                    listModel.append(results[i])
                }
            }

            Component.onCompleted: {
                update()
            }
        }

        currentIndex: -1

        delegate: BackgroundItem {
            id: delegate

            Label {
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter

                elide: Text.ElideRight

                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                text: title //name
            }
            onClicked: {
                zoneDialog.accepted(code, title);
                pageStack.pop();
            }
        }
        VerticalScrollDecorator {}
    }
}






