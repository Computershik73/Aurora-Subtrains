import QtQuick 2.0
import Sailfish.Silica 1.0
import aurora.subtrains.qmlHandler 1.0
import "pages"

ApplicationWindow
{
    property QmlHandler qmlHandler: QmlHandler { }

    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}


