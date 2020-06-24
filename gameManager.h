#ifndef MECHANICS_H
#define MECHANICS_H

#include <QObject>

class gameManager : public QObject
{
    Q_OBJECT
public:
    explicit gameManager(QObject *parent = nullptr);

    Q_INVOKABLE void fight(int defending, int attacking);    
    Q_INVOKABLE int getArmy(QString name);
    Q_INVOKABLE QString getColor(QString name);
    Q_INVOKABLE void setLand(QString name, QString army, QString player);


signals:
    void fighting(bool result, int survivorArmy);

};

#endif // MECHANICS_H
