#pragma once

#include <QObject>
#include <QQmlApplicationEngine>

using namespace Qt::Literals::StringLiterals;

class CentralManager : public QObject
{
    Q_OBJECT
public:
    explicit CentralManager(QObject *parent = nullptr);

private:
    const QString mMainQMLPath = u"qrc:/QmlCropImageTool/Main.qml"_s;
    QQmlApplicationEngine mEngine;
};

