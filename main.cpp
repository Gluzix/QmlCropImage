#include <QGuiApplication>
#include <CentralManager.h>
#include <QResource>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    Q_INIT_RESOURCE(QmlCropImageTool);

    CentralManager centralManager;

    return app.exec();
}
