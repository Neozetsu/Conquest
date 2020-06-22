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

void gameManager::setLand(QString name) //Здесь должна инициализироваться каждая земля из qml
{
    Land land;
    land.name = name;
    land.army = 1; // хз как нужно это автоматизировать
    land.player = "green"; //и это (думаю цифры и цвета стоит раздать заранее)
    map.append(land);

}

int gameManager::getArmy(QString name) //Получение числа армии по имени для qml
{
    return 0;
}

QString gameManager::getColor(QString name) //Получение цвета земли по имени для qml
{
    return "green";
}

//методы для проверки нажатия на свои земли
