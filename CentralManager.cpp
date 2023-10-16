#include "CentralManager.h"
#include <QCoreApplication>

CentralManager::CentralManager(QObject *parent)
    : QObject{parent}
{
    const QUrl url(mMainQMLPath);
    QObject::connect(&mEngine, &QQmlApplicationEngine::objectCreationFailed,
        qApp, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    mEngine.load(url);
}
