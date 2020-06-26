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
                                        imaOpacity = 1
                                        activeLand = item.objectName
                                        activeIndex = model.index
                                    }
                                    else if (activeLand == item.objectName)
                                    {
                                        imaOpacity = 0.5
                                        activeLand = ""
                                        activeIndex = -1
                                    }
                                    else if (activeLand !== item.objectName && activeLand !== "" && imaColor != activeColor)
                                    {
                                        gameManager.fight(item.objectName, activeLand)
                                        if (lastWin)
                                            imaColor = gameManager.getColor(activeLand)

                                        armyNum = lastResult.toString()
                                        listmodel.set(activeIndex, {armyNum: "0", imaOpacity: 0.5})
                                        activeLand = ""
                                    }
                                    break

                                case 2: //фаза перемещения
                                    if (activeLand == "" && imaColor == activeColor && armyNum != "0")
                                    {
                                        imaOpacity = 1
                                        activeLand = item.objectName
                                        activeIndex = model.index
                                    }
                                    else if (activeLand == item.objectName)
                                    {
                                        imaOpacity = 0.5
                                        activeLand = ""
                                        activeIndex = -1
                                    }
                                    else if (activeLand !== item.objectName && activeLand !== "" && imaColor == activeColor)
                                    {
                                        armyNum = gameManager.movement(activeLand, item.objectName).toString()
                                        listmodel.set(activeIndex, {armyNum: "0", imaOpacity: 0.5})
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
            //Первая страна
            listmodel.append({name: "1_1", sus: "resources/1_1.png", aLMargin: 113, aTMargin: 239, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "1_2", sus: "resources/1_2.png", aLMargin: 194, aTMargin: 200, imaColor: "green", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "1_3", sus: "resources/1_3.png", aLMargin: 195, aTMargin: 285, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "1_4", sus: "resources/1_4.png", aLMargin: 248, aTMargin: 283, imaColor: "red", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "1_5", sus: "resources/1_5.png", aLMargin: 234, aTMargin: 348, imaColor: "green", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "1_6", sus: "resources/1_6.png", aLMargin: 303, aTMargin: 296, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "1_7", sus: "resources/1_7.png", aLMargin: 285, aTMargin: 358, imaColor: "red", imaOpacity: 0.5, armyNum: "4"})

            //Вторая страна
            listmodel.append({name: "2_1", sus: "resources/2_1.png", aLMargin: 278, aTMargin: 438, imaColor: "green", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "2_2", sus: "resources/2_2.png", aLMargin: 327, aTMargin: 387, imaColor: "blue", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "2_3", sus: "resources/2_3.png", aLMargin: 366, aTMargin: 392, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "2_4", sus: "resources/2_4.png", aLMargin: 336, aTMargin: 319, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "2_5", sus: "resources/2_5.png", aLMargin: 384, aTMargin: 298, imaColor: "blue", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "2_6", sus: "resources/2_6.png", aLMargin: 417, aTMargin: 358, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "2_7", sus: "resources/2_7.png", aLMargin: 438, aTMargin: 289, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "2_8", sus: "resources/2_8.png", aLMargin: 474, aTMargin: 351, imaColor: "blue", imaOpacity: 0.5, armyNum: "1"})

            //Третья страна
            listmodel.append({name: "3_1", sus: "resources/3_1.png", aLMargin: 259, aTMargin: 214, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "3_2", sus: "resources/3_2.png", aLMargin: 292, aTMargin: 246, imaColor: "green", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "3_3", sus: "resources/3_3.png", aLMargin: 336, aTMargin: 275, imaColor: "blue", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "3_4", sus: "resources/3_4.png", aLMargin: 381, aTMargin: 278, imaColor: "red", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "3_5", sus: "resources/3_5.png", aLMargin: 441, aTMargin: 248, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "3_6", sus: "resources/3_6.png", aLMargin: 471, aTMargin: 208, imaColor: "blue", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "3_7", sus: "resources/3_7.png", aLMargin: 500, aTMargin: 165, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "3_8", sus: "resources/3_8.png", aLMargin: 293, aTMargin: 193, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "3_9", sus: "resources/3_9.png", aLMargin: 337, aTMargin: 236, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "3_10", sus: "resources/3_10.png", aLMargin: 382, aTMargin: 216, imaColor: "red", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "3_11", sus: "resources/3_11.png", aLMargin: 425, aTMargin: 194, imaColor: "green", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "3_12", sus: "resources/3_12.png", aLMargin: 442, aTMargin: 142, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "3_13", sus: "resources/3_13.png", aLMargin: 325, aTMargin: 175, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "3_14", sus: "resources/3_14.png", aLMargin: 362, aTMargin: 156, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "3_15", sus: "resources/3_15.png", aLMargin: 401, aTMargin: 140, imaColor: "blue", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "3_16", sus: "resources/3_16.png", aLMargin: 373, aTMargin: 110, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})

            //Четвёртая страна
            listmodel.append({name: "4_1", sus: "resources/4_1.png", aLMargin: 518, aTMargin: 347, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "4_2", sus: "resources/4_2.png", aLMargin: 554, aTMargin: 321, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "4_3", sus: "resources/4_3.png", aLMargin: 607, aTMargin: 292, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "4_4", sus: "resources/4_4.png", aLMargin: 662, aTMargin: 322, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "4_5", sus: "resources/4_5.png", aLMargin: 721, aTMargin: 375, imaColor: "blue", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "4_6", sus: "resources/4_6.png", aLMargin: 490, aTMargin: 289, imaColor: "red", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "4_7", sus: "resources/4_7.png", aLMargin: 482, aTMargin: 253, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "4_8", sus: "resources/4_8.png", aLMargin: 508, aTMargin: 210, imaColor: "blue", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "4_9", sus: "resources/4_9.png", aLMargin: 547, aTMargin: 247, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "4_10", sus: "resources/4_10.png", aLMargin: 575, aTMargin: 183, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "4_11", sus: "resources/4_11.png", aLMargin: 608, aTMargin: 222, imaColor: "blue", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "4_12", sus: "resources/4_12.png", aLMargin: 659, aTMargin: 266, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "4_13", sus: "resources/4_13.png", aLMargin: 725, aTMargin: 304, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "4_14", sus: "resources/4_14.png", aLMargin: 785, aTMargin: 356, imaColor: "blue", imaOpacity: 0.5, armyNum: "2"})

            //Пятая страна
            listmodel.append({name: "5_1", sus: "resources/5_1.png", aLMargin: 618, aTMargin: 150, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "5_2", sus: "resources/5_2.png", aLMargin: 663, aTMargin: 170, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "5_3", sus: "resources/5_3.png", aLMargin: 693, aTMargin: 219, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "5_4", sus: "resources/5_4.png", aLMargin: 742, aTMargin: 242, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "5_5", sus: "resources/5_5.png", aLMargin: 798, aTMargin: 264, imaColor: "blue", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "5_6", sus: "resources/5_6.png", aLMargin: 730, aTMargin: 165, imaColor: "red", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "5_7", sus: "resources/5_7.png", aLMargin: 770, aTMargin: 183, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "5_8", sus: "resources/5_8.png", aLMargin: 826, aTMargin: 206, imaColor: "blue", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "5_9", sus: "resources/5_9.png", aLMargin: 771, aTMargin: 128, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "5_10", sus: "resources/5_10.png", aLMargin: 821, aTMargin: 149, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "5_11", sus: "resources/5_11.png", aLMargin: 810, aTMargin: 89, imaColor: "blue", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "5_12", sus: "resources/5_12.png", aLMargin: 866, aTMargin: 137, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})

            //Шестая страна
            listmodel.append({name: "6_1", sus: "resources/6_1.png", aLMargin: 813, aTMargin: 444, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "6_2", sus: "resources/6_2.png", aLMargin: 843, aTMargin: 347, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "6_3", sus: "resources/6_3.png", aLMargin: 857, aTMargin: 285, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "6_4", sus: "resources/6_4.png", aLMargin: 879, aTMargin: 223, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "6_5", sus: "resources/6_5.png", aLMargin: 911, aTMargin: 375, imaColor: "blue", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "6_6", sus: "resources/6_6.png", aLMargin: 915, aTMargin: 311, imaColor: "red", imaOpacity: 0.5, armyNum: "4"})
            listmodel.append({name: "6_7", sus: "resources/6_7.png", aLMargin: 915, aTMargin: 252, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "6_8", sus: "resources/6_8.png", aLMargin: 955, aTMargin: 283, imaColor: "blue", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "6_9", sus: "resources/6_9.png", aLMargin: 968, aTMargin: 236, imaColor: "red", imaOpacity: 0.5, armyNum: "3"})

            //Седьмая страна
            listmodel.append({name: "7_1", sus: "resources/7_1.png", aLMargin: 728, aTMargin: 105, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "7_2", sus: "resources/7_2.png", aLMargin: 751, aTMargin: 80, imaColor: "blue", imaOpacity: 0.5, armyNum: "3"})
            listmodel.append({name: "7_3", sus: "resources/7_3.png", aLMargin: 772, aTMargin: 56, imaColor: "red", imaOpacity: 0.5, armyNum: "1"})
            listmodel.append({name: "7_4", sus: "resources/7_4.png", aLMargin: 696, aTMargin: 61, imaColor: "green", imaOpacity: 0.5, armyNum: "2"})
            listmodel.append({name: "7_5", sus: "resources/7_5.png", aLMargin: 719, aTMargin: 41, imaColor: "blue", imaOpacity: 0.5, armyNum: "2"})

            playerTurn = 0
            activeColor = "green"
            turn.visible = true
            placementArmy.visible = true
            startGame.visible = false
            phase = 0

            for (var i = 0; i < listmodel.count; i++)
                gameManager.setLand(listmodel.get(i).name , listmodel.get(i).armyNum, listmodel.get(i).imaColor)
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
