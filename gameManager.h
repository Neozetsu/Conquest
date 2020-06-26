#ifndef MECHANICS_H
#define MECHANICS_H

#include <QObject>

class gameManager : public QObject
{
    Q_OBJECT
public:
    explicit gameManager(QObject *parent = nullptr);

    Q_INVOKABLE void fight(QString defending, QString attacking);
    Q_INVOKABLE int getArmy(QString name);
    Q_INVOKABLE QString getColor(QString name);
    Q_INVOKABLE void setLand(QString name, QString army, QString player, int index);
    Q_INVOKABLE int changeArmy(QString name);
    Q_INVOKABLE int movement(QString object, QString subject);
    Q_INVOKABLE void readNeighbors();
    Q_INVOKABLE bool isNeighbor(int obj, int subj);
    Q_INVOKABLE QStringList readData(int index);
    Q_INVOKABLE bool checkWin(QString color);

    int randomBetween(int low, int high);

signals:
    void fighting(bool win, int result);
};

#endif // MECHANICS_H
