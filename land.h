#ifndef LAND_H
#define LAND_H

#include <QObject>

class land : public QObject
{
    Q_OBJECT
public:
    explicit land(QObject *parent = nullptr);
    void createLand(QString id);

signals:

};

#endif // LAND_H
