#include "gameManager.h"
#include "land.h"

gameManager::gameManager(QObject *parent) : QObject(parent)
{

}

void gameManager::fight(int defending, int attacking)
{
    int survivorArmy;
    survivorArmy = attacking - defending;
    emit fighting(true, survivorArmy);
}

void gameManager::map()
{
    land lands[7];
    //здесь должна будет храниться вся карта в текущем состоянии
}
