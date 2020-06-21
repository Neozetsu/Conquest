#ifndef MECHANICS_H
#define MECHANICS_H

#include <QObject>

class gameManager : public QObject
{
    Q_OBJECT
public:
    explicit gameManager(QObject *parent = nullptr);

    Q_INVOKABLE void fight(int defending, int attacking);
    void map();

signals:
    void fighting(bool result, int survivorArmy);

};

#endif // MECHANICS_H
