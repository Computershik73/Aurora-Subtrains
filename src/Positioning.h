#ifndef POSREQUEST_H
#define POSREQUEST_H

#include <QObject>
#include <QGeoPositionInfo>
#include <QScopedPointer>
#include <QGeoPositionInfoSource>
#include <QString>
#include "SearchHint.h"

class Positioning : public QObject
{
    Q_OBJECT
    Q_PROPERTY (SearchHint* currentZone READ currentZone NOTIFY currentZoneReady)
    Q_PROPERTY (SearchHint* currentZoneUser WRITE setCurrentZone READ currentZoneUser NOTIFY currentZoneUserChanged)
public:
    explicit Positioning(QObject *parent = 0);

    SearchHint* currentZone() {
        return _currentZone;
    }

    SearchHint* currentZoneUser() {
        return _currentZone;
    }

    void setCurrentZone(SearchHint* zone) {
        _currentZone = zone;

        emit currentZoneUserChanged();
    }

signals:
    void currentZoneReady();
    void currentZoneUserChanged();
public slots:
    void positionUpdated(const QGeoPositionInfo &info);
private:

    SearchHint* _currentZone;

    QScopedPointer<QGeoPositionInfoSource> source;
};

#endif // POSREQUEST_H
