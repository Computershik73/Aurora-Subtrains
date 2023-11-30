import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Column {
        anchors.fill: parent
        spacing: Theme.paddingMedium

        PageHeader {
            id: header
            title: qsTr("О программе")
        }
        Label {
            text: qsTr("Suburban Trains")
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            text: qsTr("Версия 0.3.4")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DetailItem {
            id: authors
            label: qsTr("Авторы")
            value: qsTr("Евгений Файвужинский,
Тенгиз Шарафиев,
Алексей Бедник,
Артём Рапопорт,
Никита Ухрёнков,
Дмитрий Бычков,
@okabe2011 (Илья Высоцкий),
crx
")
        }

        BackgroundItem{
            width: parent.width
            height: copyr.height
            onClicked: Qt.openUrlExternally("http://rasp.yandex.ru/")
            Image {
                id: copyr
                source: "copyright.svg"
                sourceSize.width: parent.width * 0.8
                sourceSize.height: height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
