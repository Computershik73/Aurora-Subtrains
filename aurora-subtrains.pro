# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = ru.ilyavysotsky.auroraSubtrains

CONFIG += \
    auroraapp

db.files = db/
db.path = /usr/share/$${TARGET}/
INSTALLS += db

SOURCES += \
    src/QmlHandler.cpp \
    src/NearestZoneFinder.cpp \
    src/OurResource.cpp \
    src/Positioning.cpp \
    src/ValuePair.cpp \
    src/SearchHint.cpp \
    src/main.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/ThreadsPage.qml \
    qml/pages/ZonePage.qml \
    qml/pages/Util.js \
    rpm/ru.ilyavysotsky.auroraSubtrains.spec \
    rpm/ru.ilyavysotsky.auroraSubtrains.yaml \
    translations/*.ts


AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.ilyavysotsky.auroraSubtrains.ts \
    translations/ru.ilyavysotsky.auroraSubtrains-ru.ts \


# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/ru.ilyavysotsky.auroraSubtrains.ts

HEADERS += \
    src/QmlHandler.h \
    src/NearestZoneFinder.h \
    src/OurResource.h \
    src/Positioning.h \
    src/ValuePair.h \
    src/SearchHint.h \

DISTFILES += \
    qml/ru.ilyavysotsky.auroraSubtrains.qml \
    qml/views/SearchBox.qml \
    qml/pages/ThreadsPage.qml \
    qml/pages/ThreadInfo.qml \
    qml/pages/line-bot.svg \
    qml/pages/line-med.svg \
    qml/pages/line-top.svg \
    qml/pages/line-grey.svg \
    ru.ilyavysotsky.auroraSubtrains.desktop \
    qml/pages/AboutPage.qml

QT+= sql positioning
