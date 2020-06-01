#include "mechanics.h"

mechanics::mechanics(QObject *parent) : QObject(parent)
{

}

void mechanics::fight(int defending, int attacking)
{
    int survivorArmy;
    survivorArmy = attacking - defending;
    emit fighting(true, survivorArmy);
}
