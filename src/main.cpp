/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <QtQuick>

#include <auroraapp.h>
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlContext>
#include <QSqlDatabase>


#include "QmlHandler.h"
#include "Positioning.h"
#include "SearchHint.h"


void loadDb() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(Aurora::Application::pathTo("db/yandex_rasp_x.db").path());
    if (! db.open()) {
        qDebug() << db.lastError().text();
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication * sailfishRaspApp = Aurora::Application::application(argc, argv);
    sailfishRaspApp -> setApplicationName("auroraSubtrains");
    sailfishRaspApp -> setOrganizationName("ru.ilyavysotsky");

    loadDb();

    qmlRegisterType<QmlHandler>("aurora.subtrains.qmlHandler", 1, 0, "QmlHandler");
    qmlRegisterType<Positioning>("aurora.subtrains.positioning", 1, 0, "Positioning");
    qmlRegisterType<SearchHint>("aurora.subtrains.searchHint", 1, 0, "SearchHint");

    QQuickView* qView = Aurora::Application::createView();
    qView->setSource(Aurora::Application::pathTo("qml/ru.ilyavysotsky.aurora-subtrains.qml"));
    qView->show();

    return sailfishRaspApp -> exec();
}

