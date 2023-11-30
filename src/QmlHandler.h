#ifndef QMLHANDLER_H
#define QMLHANDLER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QQmlListProperty>
#include <QtSql/QtSql>
#include "SearchHint.h"

class QmlHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY (QJsonArray routeModel READ routeModel NOTIFY routeModelChanged)
    Q_PROPERTY (QVariant trainInfoModel READ trainInfoModel NOTIFY trainInfoModelChanged)
    Q_PROPERTY (QVariant alerttext READ alerttext NOTIFY alerttextChanged)
   // Q_PROPERTY (QVariant aa READ aa NOTIFY threadsListRecieved)
   // Q_PROPERTY (QVariant aaa READ aaa NOTIFY errorRecievingThreads)
public:
    explicit QmlHandler(QObject *parent = 0);

    Q_INVOKABLE void getRoute(QString originStation, QString destStation, bool is_meta_from, bool is_meta_to, QDate tripDate);
    Q_INVOKABLE void getTrainInfo(QString threadId, QDate tripDate);

    Q_INVOKABLE QList<QObject*> getStationHints(QString text, int zone);
    Q_INVOKABLE QList<QObject*> getZonesLike(QString text);
    Q_INVOKABLE QList<QObject*> getAllZones();

    QJsonArray routeModel()
    {
        return m_routeModel;
    }

    QVariant trainInfoModel()
    {
        return m_trainInfoModel;
    }
    QVariant alerttext() {
        return m_alerttext;
    }
  /*  QVariant aaa() {
        return m_aaa;
    }

    QVariant aa() {
        return m_aa;
    }*/


signals:
    void routeModelChanged();
    void trainInfoModelChanged();
    void threadsListRecieved();
    void errorRecievingThreads();
    void alerttextChanged();
public slots:
    void onGetRouteFinished(QNetworkReply* netReply);
    void onGetTrainInfoFinished(QNetworkReply* netReply);

private:
    QJsonArray m_routeModel;
    QVariant  m_alerttext;
    QVariant m_trainInfoModel;
   // QVariant m_aa;
    //QVariant m_aaa;

    void setRouteModel(const QJsonArray newRtModel);
    void setAlertText(QVariant newAlertText);

};

#endif // QMLHANDLER_H
