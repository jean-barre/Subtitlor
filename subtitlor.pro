QT += quick quickcontrols2 multimedia

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

include ($$PWD/src/cpp/cpp.pri)

INCLUDEPATH += \
    $$PWD/src/cpp \
    $$PWD/src/cpp/common \

SOURCES += \
        main.cpp \

RESOURCES += src/qml.qrc \
    res/img.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
