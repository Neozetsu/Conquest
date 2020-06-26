#include "gameManager.h"
#include <QColor>
#include <math.h>
#include <QDebug>
#include <iostream>


class Land
{
  public:
    QString name;
    int army;
    QString player;
    QList<QString> neighbors;
};

QList<Land> map; //на будущее можно сделать массивом, т.к. карта всегда фиксированного размера

gameManager::gameManager(QObject *parent) : QObject(parent)
{

}

void gameManager::fight(QString defending, QString attacking) //Просчёт боя и изменение значений
{
    int def;
    int att;
    for (int i = 0; i < map.length(); i++) //нахождение сражающихся земель
    {
        if (map[i].name == defending)
            def = map[i].army;
        if (map[i].name == attacking)
            att = map[i].army;

    }
    while (def != 0 && att != 0) //сама боёвка через qrand
    {
        if (randomBetween(0,1) == 0)

            att -= 1;
        else
            def -= 1;
        //qDebug()<<randomBetween(0,1);
    }
    bool win;
    int result;
    if (def == 0)
    {
        win = true;
        result = att;
    }
    else
    {
        win = false;
        result = def;

    }
    QString color;
    for (int i = 0; i < map.length(); i++) //запись изменений после боя в map
    {
        if (win)
        {
            if (map[i].name == attacking)
            {
                map[i].army = 0;
                color = map[i].player;
            }
            if (map[i].name == defending)
            {
                map[i].army = att;
            }
        }
        else
        {
            if (map[i].name == defending)
                map[i].army = def;
            if (map[i].name == attacking)
            {
                map[i].army = 0;
            }
        }
    }

    if (win)
        for (int i = 0; i < map.length(); i++)
        {
            if (map[i].name == defending)
                map[i].player = color;

        }

    emit fighting(win, result); //вывод результата через сигнал
}

int gameManager::randomBetween(int low, int high) //рандом между двумя числами
{
    return (qrand() % ((high + 1) - low) + low);

}

int gameManager::getArmy(QString name) //Получение числа армий по имени для qml
{
    int result;
    for (int i = 0; i < map.length(); i++)
        if (map[i].name == name)
            result = map[i].army;
    return result;
}

QString gameManager::getColor(QString name) //Получение цвета земли по имени для qml
{
    QString result;
    for (int i = 0; i < map.length(); i++)
        if (map[i].name == name)
            result = map[i].player;
    return result;
}

void gameManager::setLand(QString name, QString army, QString player) //Создание земли в map
{
    Land land;
    land.name = name;
    land.army = army.toInt();
    land.player = player;
    map.append(land);
}

int gameManager::changeArmy(QString name) //Изменение армий при расстановке подкреплений
{
    int result;
    for (int i = 0; i < map.length(); i++)
        if (map[i].name == name)
        {
            map[i].army += 1;
            result = map[i].army;
        }
    return result;
}

int gameManager::movement(QString object, QString subject) //передвижение армий после атак
{
    int result;
    int objArmy;
    for (int i = 0; i < map.length(); i++)
    {
        if (map[i].name == object && map[i].army > 0)
        {
            objArmy = map[i].army;
            map[i].army = 0;
        }
    }

    for (int i = 0; i < map.length(); i++)
    {
        if (map[i].name == subject)
        {
            map[i].army += objArmy;
            result = map[i].army;
        }
    }
    return result;
}
