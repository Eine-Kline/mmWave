QT       += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
TARGET = serialtool
TEMPLATE = app
DEPENDPATH += . src ui
INCLUDEPATH += . src


# Input
HEADERS += src/myqcombobox.h src/myqlineedit.h src/serialtool.h
FORMS += ui/serialtool.ui
SOURCES += src/comtoolmain.cpp src/serialtool.cpp
RESOURCES += ui/myresource.qrc

# Output
UI_DIR = out
RCC_DIR = out
MOC_DIR = out
OBJECTS_DIR = out
DESTDIR = out
