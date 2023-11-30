import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    Image {
        id: icon
        source: "icon.svg"
        sourceSize.width: width
        sourceSize.height: height
        width: parent.width * 0.6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
    }


    Label {
        id: label
        text: ("\nSuburban\nTrains")
        anchors.top: icon.bottom
        width: icon.width
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
