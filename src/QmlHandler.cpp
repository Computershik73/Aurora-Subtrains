#include "QmlHandler.h"
#include "OurResource.h"

QmlHandler::QmlHandler(QObject *parent) : QObject(parent)
{
}

void QmlHandler::setRouteModel(const QJsonArray newRtModel)
{
    m_routeModel = newRtModel;
    emit routeModelChanged();
}

void QmlHandler::setAlertText(QVariant newAlertText)
{
    m_alerttext = newAlertText;
    emit alerttextChanged();
}

void QmlHandler::getTrainInfo(QString threadId, QDate tripDate)
{

    QNetworkAccessManager* m_pNetAccessMngr =
            new QNetworkAccessManager(this);

    QUrl reqUrl = QUrl("https://api.rasp.yandex.net/v1.0/thread/");
    QUrlQuery urlQuery;
    urlQuery.addQueryItem("apikey", OurResource::getApiKey());
    urlQuery.addQueryItem("format","json");
    urlQuery.addQueryItem("lang","ru");
    urlQuery.addQueryItem("uid", threadId);
    urlQuery.addQueryItem("date",tripDate.toString("yyyy-MM-dd"));

    reqUrl.setQuery(urlQuery);

    QNetworkRequest request = QNetworkRequest();
    request.setUrl(reqUrl);

    bool res;
    Q_UNUSED(res);

    res = connect(m_pNetAccessMngr,
                  SIGNAL(finished(QNetworkReply*)),
                  this,
                  SLOT(onGetTrainInfoFinished(QNetworkReply*)));
    Q_ASSERT(res);

    m_pNetAccessMngr->get(request);
}


void QmlHandler::getRoute(QString originStation, QString destStation, bool is_meta_from, bool is_meta_to, QDate tripDate)
{
    QNetworkAccessManager* m_pNetAccessMngr =
            new QNetworkAccessManager(this);

    QUrl reqUrl = QUrl("http://export.rasp.yandex.net/v3/suburban/search_on_date");
    QUrlQuery urlQuery;
    //urlQuery.addQueryItem("apikey", OurResource::getApiKey());
    urlQuery.addQueryItem("add_subtype","true");
    urlQuery.addQueryItem(is_meta_from ? "city_from" : "station_from",originStation);
    urlQuery.addQueryItem(is_meta_to ? "city_to" : "station_to", destStation);
    urlQuery.addQueryItem("lang","ru_RU");
    urlQuery.addQueryItem("transfers","false");
    urlQuery.addQueryItem("selling","false");
    urlQuery.addQueryItem("disable_cancels","true");


    urlQuery.addQueryItem("date",tripDate.toString("yyyy-MM-dd"));


    reqUrl.setQuery(urlQuery);

    QNetworkRequest request = QNetworkRequest();
    request.setUrl(reqUrl);
    qDebug() << reqUrl.toString();

    bool res;
    Q_UNUSED(res);

    res = connect(m_pNetAccessMngr,
                  SIGNAL(finished(QNetworkReply*)),
                  this,
                  SLOT(onGetRouteFinished(QNetworkReply*)));
    Q_ASSERT(res);

    m_pNetAccessMngr->get(request);
}

void QmlHandler::onGetRouteFinished(QNetworkReply *netReply)
{
    QVariantList dataList;

    if (netReply != NULL &&
            netReply->bytesAvailable() > 0 &&
            netReply->error() == QNetworkReply::NoError)
    {
        QString replyStr = netReply->readAll();
        //qDebug() << replyStr;
        QJsonDocument jsonResponse = QJsonDocument::fromJson(replyStr.toUtf8());
        QJsonObject jsonObject = jsonResponse.object();
        QJsonArray days = jsonObject["days"].toArray();
        QJsonObject today = days.at(0).toObject();
        QJsonArray jsonArray = today["segments"].toArray();

        //if (jsonObject.contains("teasers")) {}
        for (int i = 0; i < jsonArray.size(); i++)
        {
            QJsonObject obj = jsonArray.at(i).toObject();
            obj.insert("hasAlreadyLeft",
                       (QDateTime::currentDateTime() >=
                        QDateTime::fromString(obj.value("departure").toObject().value("time").toString())));

            jsonArray.replace(i, obj);
        }

        setRouteModel(jsonArray);

        emit threadsListRecieved();
    }
    else
    {
        emit errorRecievingThreads();
    }
}

void QmlHandler::onGetTrainInfoFinished(QNetworkReply* netReply)
{
    if(netReply != NULL
            && netReply->bytesAvailable() > 0
            && netReply->error() == QNetworkReply::NoError)
    {

        m_trainInfoModel = QJsonDocument::fromJson(
                    ((QString)netReply->readAll())
                    .toUtf8()).toVariant();

        emit trainInfoModelChanged();
    }
}

QList<QObject*> QmlHandler::getStationHints(QString text, int zone)
{
    QSqlQuery query;

    query.prepare("SELECT title, esr, is_meta FROM station JOIN zones_stations ON station.id = zones_stations.station_id WHERE zones_stations.zone_id = ? AND title LIKE ? COLLATE utf8_general_ci ORDER BY importance LIMIT 5;");
    query.addBindValue(zone);
    query.addBindValue("%" + text.toUpper() + "%");

    if (!query.exec()) {
        qDebug() << "SQL query error: " << query.lastError().text();
    }

    QSqlRecord rec = query.record();
    QList<QObject*> hints;

    while (query.next()) {
        QString esr = query.value(rec.indexOf("esr")).toString();
        QString title = query.value(rec.indexOf("title")).toString();
        bool is_meta = query.value(rec.indexOf("is_meta")).toBool();
        hints.append(new SearchHint(title, esr, is_meta));
    }

    return hints;
}

QList<QObject *> QmlHandler::getZonesLike(QString text)
{
    QSqlQuery query;

    query.prepare("select id, settlementTitle from zone "
                  "where settlementTitle LIKE :settlement_title "
                  "order by settlementTitle ASC");
    query.bindValue(":settlement_title", "%" + text.toUpper() + "%");
    query.exec();

    QList<QObject*> zones;
    while (query.next()) {
        zones.append(new SearchHint(
                         query.value("settlementTitle").toString()
                         , query.value("id").toString(), true
                         ));
    }

    return zones;
}

QList<QObject *> QmlHandler::getAllZones()
{
    QSqlQuery query;

    query.exec("select id, settlementTitle from zone "
                  "order by settlementTitle ASC");

    QList<QObject*> zones;
    while (query.next()) {
        zones.append(new SearchHint(
                         query.value("settlementTitle").toString()
                         , query.value("id").toString(), true
                         ));
    }

    return zones;
}
