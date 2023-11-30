import QtQuick 2.0
import Sailfish.Silica 1.0
import aurora.subtrains.positioning 1.0
import aurora.subtrains.searchHint 1.0
import aurora.subtrains.qmlHandler 1.0

Page
{
    property QmlHandler qmlHandler;
    SilicaListView {
        id: sListView
        model: qmlHandler.trainInfoModel.stops
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Интервалы остановок")
        }
        delegate: ListItem {
            id: delegate
            enabled: false
            property int indexOfThisDelegate: index
            height: Theme.itemSizeMedium
            width: parent.width

            Image {
                id: image

                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }

                source:
                    if (index === 0)
                    {"line-top.svg"}
                    else {
                        if (index === sListView.count-1)
                        {"line-bot.svg"}
                        else
                        {
                            if (!modelData.stop_time)
                            {"line-grey.svg"}
                            else {
                                "line-med.svg"}
                        }}

                width: Theme.itemSizeMedium
                height: Theme.itemSizeMedium
                sourceSize.width: width
                sourceSize.height: height
            }

            Label {
                anchors.left: image.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: time.left
                anchors.rightMargin: Theme.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.station.title
                truncationMode: TruncationMode.Fade
                color: if (!modelData.stop_time && index !== 0 && index !== sListView.count-1)
                       {Theme.secondaryColor} else
                       {Theme.primaryColor}
            }

            Label {
                id: time
                width: 90
                anchors {
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                font.pixelSize: Theme.fontSizeSmall
                text: {
                    var resultText = "";
                    if (modelData.stop_time || index === 0 || index === sListView.count-1)
                    {
                        // if (modelData.arrival === "" || modelData.departure === "")

                        resultText = ( (modelData.arrival ? modelData.arrival.substring(11, 16) : "")
                                      + (modelData.arrival ? modelData.departure ? " –\r\n" : "" : "" )
                                      + (modelData.departure ? modelData.departure.substring(11, 16) : "") );
                    }
                    return resultText;
                }
                font.bold: false
                horizontalAlignment: Text.AlignRight
            }
        }
        VerticalScrollDecorator{}
    }
}
