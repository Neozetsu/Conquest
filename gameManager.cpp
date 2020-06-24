#include "gameManager.h"
#include <QColor>

class Land
{
  public:
    QString name;
    int army;
    QString player;
    QList<QString> neighbors;

};

//здесь хранится вся текущая карта (нужно массивом)
QList<Land> map;

gameManager::gameManager(QObject *parent) : QObject(parent)
{

}

void gameManager::fight(int defending, int attacking) //Здесь должен быть расчёт боя (получаемые параметры должны быть 2 имени)
{
    int survivorArmy;
    survivorArmy = attacking - defending;
    emit fighting(true, survivorArmy);
}

int gameManager::getArmy(QString name) //Получение числа армии по имени для qml
{
    return 0;
}

QString gameManager::getColor(QString name) //Получение цвета земли по имени для qml
{
    return "purple";
}

void gameManager::setLand(QString name, QString army, QString player)
{
    Land land;
    land.name = name;
    land.army = army.toInt();
    land.player = player;
    map.append(land);
}

//методы для проверки нажатия на свои земли
