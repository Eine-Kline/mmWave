
QT       += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = wifiLocation
TEMPLATE = app

DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += \
        main.cpp \
    RadarSimulator.cpp
HEADERS += \
    RadarSimulator.h
FORMS += \
        mainwindow.ui
RESOURCES += \
    rardasimulator.qrc
