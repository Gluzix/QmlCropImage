#include "CentralManager.h"
#include <QCoreApplication>

CentralManager::CentralManager(QObject *parent)
    : QObject{parent}
{

    const QUrl url(mMainQMLPath);
    QObject::connect(&mEngine, &QQmlApplicationEngine::objectCreationFailed,
        qApp, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterSingletonInstance("Qt.cropTool.cropHandlerSingleton", 1, 0, "CropHandler", &mCropHandler);
    mEngine.load(url);

}
