#ifndef MECHANICS_H
#define MECHANICS_H

#include <QObject>

class mechanics : public QObject
{
    Q_OBJECT
public:
    explicit mechanics(QObject *parent = nullptr);

    Q_INVOKABLE void fight(int defending, int attacking);

signals:
    void fighting(bool result, int survivorArmy);

};

#endif // MECHANICS_H
