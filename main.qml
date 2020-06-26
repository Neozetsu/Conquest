import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import GameManager 1.0
import QtQuick.Controls 2.5

Window {
    visible: true
    title: "Conquest"
    minimumHeight: 640
    maximumHeight: 640
    minimumWidth: 1200
    maximumWidth: 1200

    property int phase; //фазы хода игрока: 0 - размещение, 1 - ход, 2 - перемещение
    property string activeLand //текущая нажатая земля
    property int activeIndex //индекс текущей нажатой земли
    property string activeColor //цвет текущего игрока
    property bool lastWin //результат последней битвы
    property int lastResult //число выживших в последней битве
    property int playerTurn //флажок на ход игроков: 0 - зелёный, 1 - красный, 2 - синий

    GameManager { //Игровой менеджер
        id: gameManager
        onFighting:
        {
            lastWin = win
            lastResult = result
        }
    }

    Image { //главная картинка заднего фона (белая карта)
        id: myMap
        width: parent.width
        height: parent.height
        source: "resources/MyMap.png"
        ListView { //ListView содержащий делегат для динамического создания объекта
            id: listview
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            delegate: Item{
                id: item
                objectName: name
                Image {
                    source: sus
                    anchors.left: parent.left
                    anchors.leftMargin: aLMargin
                    anchors.top: parent.top
                    anchors.topMargin: aTMargin
                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: imaColor
                        opacity: imaOpacity
                    }
                    Text {
                        text: armyNum
                        font.pixelSize: 22
                        anchors.centerIn: parent
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                switch (phase)
                                {
                                case 0: //фаза расстановки
                                    if (imaColor == activeColor)
                                    {
                                        armyNum = gameManager.changeArmy(item.objectName).toString()
                                        placementArmy.text -= 1;
                                        if (placementArmy.text == "0")
                                        {
                                            finishPlacement.visible = true
                                            phase = -1
                                        }
                                    }
                                    break

                                case 1: //фаза хода
                                    if(activeLand == "" && imaColor == activeColor && armyNum != "0")
                                    {
                                        imaOpacity = "1"
                                        activeLand = item.objectName
                                        activeIndex = model.index
                                    }
                                    else if (activeLand == item.objectName)
                                    {
                                        imaOpacity = "0.5"
                                        activeLand = ""
                                        activeIndex = -1
                                    }
                                    else if (activeLand !== item.objectName && activeLand !== "" && imaColor != activeColor && gameManager.isNeighbor(activeIndex, model.index))
                                    {
                                        gameManager.fight(item.objectName, activeLand)
                                        if (lastWin)
                                            imaColor = gameManager.getColor(activeLand)

                                        armyNum = lastResult.toString()
                                        listmodel.set(activeIndex, {armyNum: "0", imaOpacity: "0.5"})
                                        activeLand = ""                                        
                                    }
                                    break

                                case 2: //фаза перемещения
                                    if (activeLand == "" && imaColor == activeColor && armyNum != "0")
                                    {
                                        imaOpacity = "1"
                                        activeLand = item.objectName
                                        activeIndex = model.index
                                    }
                                    else if (activeLand == item.objectName)
                                    {
                                        imaOpacity = "0.5"
                                        activeLand = ""
                                        activeIndex = -1
                                    }
                                    else if (activeLand !== item.objectName && activeLand !== "" && imaColor == activeColor && gameManager.isNeighbor(activeIndex, model.index))
                                    {
                                        armyNum = gameManager.movement(activeLand, item.objectName).toString()
                                        listmodel.set(activeIndex, {armyNum: "0", imaOpacity: "0.5"})
                                        activeLand = ""
                                        numberOfMoves.text -= 1
                                        if (numberOfMoves.text == "0")
                                        {
                                            phase = -1
                                        }
                                    }
                                    break
                                case -1: //дефолтная фаза (отключение интерактивности)
                                    break
                                }
                            }
                        }
                    }
                }
            }
            model: ListModel {
                id: listmodel
            }
        }
    }
    Button { //Кнопка начала игры
        id: startGame
        text: "Start Game"
        font.pixelSize: 32
        width: 200
        height: 50
        anchors.centerIn: parent
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "burlywood"
        }

        onClicked: {
            gameManager.readNeighbors()
            for (var i = 0; i < 71; i++)
            {
                var data  = gameManager.readData(i);
                listmodel.append({name: data[0], sus: data[1], aLMargin: data[2], aTMargin: data[3], imaColor: data[4], imaOpacity: data[5], armyNum: data[6]});
            }
            playerTurn = 0
            activeColor = "green"
            turn.visible = true
            placementArmy.visible = true
            startGame.visible = false
            phase = 0

            for (var j = 0; j < listmodel.count; j++)
                gameManager.setLand(listmodel.get(j).name , listmodel.get(j).armyNum, listmodel.get(j).imaColor, j)
        }
    }
    Rectangle { //Пользовательский интерфейс
        id: userInterface
        width: parent.width
        height: 50
        anchors.bottom: parent.bottom
        color: "burlywood"
        Text { //Текст с количеством подкреплений
            id: placementArmy
            visible: false
            text: "3"
            font.pixelSize: 24
            anchors.centerIn: parent
            Text {
                id: holderArmyText
                text: "Reinforcements left:"
                font.pixelSize: 20
                anchors.right: parent.left
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Text {
            visible: false
            id: movesLeft
            text: "Moves left:"
            font.pixelSize: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 450
            Text {
                id: numberOfMoves
                text: "3"
                font.pixelSize: 24
                anchors.left: parent.right
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Text { //Текст, подсказывающий, чей сейчас ход
            id: turn
            visible: false
            text: "Green Turn"
            color: "green"
            font.pixelSize: 24
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Button { //Кнопка смены фазы с размещения на атаку
        visible: false
        id: finishPlacement
        text: "Finish placement"
        font.pixelSize: 20
        width: 180
        height: 30
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked:
        {
            placementArmy.text = "3" //Изменить под плюсы
            placementArmy.visible = false
            phase = 1
            finishPlacement.visible = false
            finishAttacks.visible = true
        }
    }
    Button { //Кнопка смены фазы с атаки на перемещение
        visible: false
        id: finishAttacks
        text: "Finish Attacks"
        font.pixelSize: 20
        width: 180
        height: 30
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked:
        {
            movesLeft.visible = true
            endTurn.visible = true
            phase = 2
            finishAttacks.visible = false
            if (gameManager.checkWin(activeColor))
            {
                phase = -1
                winTable.visible = true;
            }
        }
    }
    Button { //Кнопка смены фазы на размещение и передачу хода другому игроку
        visible: false
        id: endTurn
        text: "Finish Moving"
        font.pixelSize: 20
        width: 180
        height: 30
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked:
        {
            movesLeft.visible = false
            numberOfMoves.text = "3"
            phase = 0
            endTurn.visible = false
            placementArmy.visible = true
            if (playerTurn == 2)
                playerTurn = 0
            else
                playerTurn += 1

            switch (playerTurn)
            {
            case 0:
                turn.text = "Green Turn"
                activeColor = "green"
                turn.color = activeColor
                break;
            case 1:
                turn.text = "Red Turn"
                activeColor = "red"
                turn.color = activeColor
                break;
            case 2:
                turn.text = "Blue Turn"
                activeColor = "blue"
                turn.color = activeColor
                break;
            //можно добавлять сколько угодно
            }

        }
    }
    Rectangle { //Табличка с надписью победы (НЕ РЕАЛИЗОВАНО)
        visible: false
        id: winTable
        anchors.centerIn: parent
        height: 110
        width: 280
        ColorOverlay {
            anchors.fill: parent
            color: "burlywood"
        }
        Text {
            id: winText
            text: "Victory!"
            color: "red"
            font.pixelSize: 60
            anchors.centerIn: parent
        }
    }
}
