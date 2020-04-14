#ifndef FILE_H
#define FILE_H

#include <QObject>

class File : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileURL READ fileURL WRITE setFileURL NOTIFY fileURLChanged)
    Q_PROPERTY(QList<QString> extensions READ extensions NOTIFY extensionsChanged)

public:
    enum FileType {
        VIDEO,
        SRT
    };
    explicit File(QObject *parent = nullptr, FileType fileType = FileType::VIDEO);

    QString fileURL();
    QList<QString> extensions();

    void setFileURL(const QString&);
    bool isValid();

private:
    QString q_fileURL;
    FileType fileType;
    QList<QString> q_extensions;

public:
    static const QList<QString> videoExtensions;
    static const QList<QString> srtExtensions;

signals:
    void fileURLChanged();
    void extensionsChanged();

public slots:
    void tryFileURL(const QString& fileUrl);

};

#endif // FILE_H
