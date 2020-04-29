#ifndef EXPORTCONTROLLER_H
#define EXPORTCONTROLLER_H

#include <QObject>

class ExportController : public QObject
{
    Q_OBJECT
public:
    explicit ExportController(QObject *parent = nullptr);

    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged)
    Q_PROPERTY(QString directoryURL READ directoryURL WRITE setDirectoryURL NOTIFY directoryURLChanged)
    Q_PROPERTY(bool overriding READ overriding NOTIFY overridingChanged)
    Q_PROPERTY(QString destinationURL READ destinationURL NOTIFY destinationURLChanged)

    QString filename() const;
    QString directoryURL() const;
    bool overriding() const;
    QString destinationURL() const;

    void setFilename(const QString);
    void setDirectoryURL(const QString);

private:
    QString q_filename = "myVideoSubtitles";
    QString q_directoryURL = "...";
    bool q_overriding = false;
    QString q_destinationURL = "";

    void setOverriding(const bool);

signals:
    void directoryURLChanged();
    void filenameChanged();
    void overridingChanged();
    void destinationURLChanged();

private slots:
    void updateDestinationURL();
    void presetFields(const bool editionUseCase, const QString);

};

#endif // EXPORTCONTROLLER_H
