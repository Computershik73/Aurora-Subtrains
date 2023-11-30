#ifndef NEARESTZONEFINDER_H
#define NEARESTZONEFINDER_H

#include <QGeoCoordinate>
#include "ValuePair.h"

class NearestZoneFinder
{
public:
    static ValuePair findNearestZone(const QGeoCoordinate& coordinate);
    static ValuePair getZoneById(const int zone);
};

#endif // NEARESTZONEFINDER_H
