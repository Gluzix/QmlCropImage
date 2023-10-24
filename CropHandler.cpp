#include "CropHandler.h"
#include <QFileDialog>
#include <QIODevice>

CropHandler::CropHandler(QObject *parent)
    : QObject{parent}
{

}

void CropHandler::cropImage(QRect newSize)
{
    QFileDialog *dialog = new QFileDialog();
    dialog->setAttribute(Qt::WA_DeleteOnClose);
    dialog->setAcceptMode(QFileDialog::AcceptSave);
    dialog->setNameFilters(supportedFilters);

    connect(dialog, &QFileDialog::accepted, this, [dialog, this, newSize]() {
        QImage newImage = mOriginalImage.copy(newSize);
        QStringList selectedFiles = dialog->selectedFiles();
        if (selectedFiles.size() == 0) {
            return;
        }
        QString path = dialog->selectedFiles().at(0);
        newImage.save(path);
    });
    connect(dialog, &QFileDialog::filterSelected, this, [dialog](QString filterSelected) {
        dialog->setDefaultSuffix(filterSelected);
    });
    connect(dialog, &QObject::destroyed, this, [dialog]() mutable {
        dialog = nullptr;
    });
    dialog->open();
}

QImage CropHandler::originalImage() const
{
    return mOriginalImage;
}

void CropHandler::openNewImage(QString urlToFile)
{
    QString pathToFile = QString();
    const QUrl url(urlToFile);

    if (url.isLocalFile()) {
        pathToFile = QDir::toNativeSeparators(url.toLocalFile());
    } else {
        pathToFile = urlToFile;
    }

    mOriginalImage.load(pathToFile);
    setOriginalImageUrl(urlToFile);

    emit originalImageChanged();
}

QUrl CropHandler::originalImageUrl() const
{
    return mOriginalImageUrl;
}

void CropHandler::setOriginalImageUrl(const QUrl &newOriginalImageUrl)
{
    if (mOriginalImageUrl == newOriginalImageUrl) {
        return;
    }
    mOriginalImageUrl = newOriginalImageUrl;
    emit originalImageUrlChanged();
}
