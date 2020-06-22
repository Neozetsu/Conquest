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

    void setLand(QString name);


signals:
    void fighting(bool result, int survivorArmy);

};

#endif // MECHANICS_H
