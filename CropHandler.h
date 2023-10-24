#pragma once

#include <QObject>
#include <QUrl>
#include <QImage>

class CropHandler : public QObject
{
    Q_OBJECT
public:
    explicit CropHandler(QObject *parent = nullptr);
    Q_INVOKABLE void cropImage(QRect newSize);
    Q_INVOKABLE void openNewImage(QString urlToFile);
    QImage originalImage() const;
    QUrl originalImageUrl() const;

signals:
    void originalImageChanged();
    void originalImageUrlChanged();

private:
    void setOriginalImageUrl(const QUrl &newOriginalImageUrl);

    QImage mOriginalImage;
    QUrl mOriginalImageUrl;

    Q_PROPERTY(QImage originalImage READ originalImage NOTIFY originalImageChanged FINAL)
    Q_PROPERTY(QUrl originalImageUrl READ originalImageUrl NOTIFY originalImageUrlChanged FINAL)

    const QStringList supportedFilters {".png", ".jpg"};
};

