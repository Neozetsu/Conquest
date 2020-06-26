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


    property string activeLand //текущая нажатая земля
    property bool lastWin //результат последней битвы
    property int lastResult //число выживших в последней битве
    property bool placement //флажок на ход размещения
    property bool playerTurn //флажок на ход игроков: true - зелёный, false - красный

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
                        font.pixelSize: 24
                        anchors.centerIn: parent
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {                               
                                //Сделать нормальные флажки для хода игроков (?) НЕ РЕШЕНО
                                if (placement && playerTurn && imaColor == "green" || placement && !playerTurn && imaColor == "red")
                                { //Условия для расстановки подкреплений
                                    gameManager.setArmy(item.objectName)
                                    armyNum = gameManager.getArmy(item.objectName)
                                    placementArmy.text -= 1;
                                    if (placementArmy.text == "0")
                                    {
                                        placement = false;
                                        placementArmy.visible = false;
                                    }
                                }
                                else
                                { //Остальные действия (выбор армии, атака, перемещение)
                                    armyNum = gameManager.getArmy(item.objectName)
                                    console.log(item.objectName)
                                    if(activeLand == "")
                                    {
                                        imaOpacity = 1
                                        activeLand = item.objectName

                                    }

                                    else if (activeLand == item.objectName)
                                    {
                                        imaOpacity = 0.5
                                        activeLand = ""
                                    }

                                    else if (activeLand !== item.objectName)
                                    {
                                        gameManager.fight(item.objectName, activeLand)
                                        if (lastWin)
                                        {
                                            activeLand.text = 0; //Обращение к текстовому полю другого объекта (?) НЕ РЕШЕНО
                                            armyNum = lastResult.toString()
                                            imaColor = gameManager.getColor(activeLand)
                                        }
                                        else
                                        {
                                            armyNum = lastResult.toString()
                                            activeLand.text = 0; //Обращение к текстовому полю другого объекта (?) НЕ РЕШЕНО
                                        }
                                        activeLand.opacity = 0.5 //Обращение к цвету другого объекта (?) НЕ РЕШЕНО
                                        activeLand = ""
                                    }
                                    else
                                    {
                                        activeLand.opacity = 0.5 //Обращение к цвету другого объекта (?) НЕ РЕШЕНО
                                        activeLand = ""
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Button{
                id: button
                text: "aaaaaaaaa"
                onClicked: {
                    listmodel.set(0, {armyNum: "50", imaOpacity: 1})
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
            listmodel.append({name: "1_1", sus: "resources/1_1.png", aLMargin: 113, aTMargin: 239, imaColor: "red", imaOpacity: 0.5, armyNum: "2"})
            gameManager.setLand("1_1", "2", "red")

            listmodel.append({name: "1_2", sus: "resources/1_2.png", aLMargin: 194, aTMargin: 200, imaColor: "green", imaOpacity: 0.5, armyNum: "5"})
            gameManager.setLand("1_2", "5", "green")

            listmodel.append({name: "1_3", sus: "resources/1_3.png", aLMargin: 195, aTMargin: 285, imaColor: "green", imaOpacity: 0.5, armyNum: "8"})
            gameManager.setLand("1_3", "8", "green")

            listmodel.append({name: "1_4", sus: "resources/1_4.png", aLMargin: 248, aTMargin: 283, imaColor: "red", imaOpacity: 0.5, armyNum: "4"})
            gameManager.setLand("1_4", "4", "red")

            listmodel.append({name: "1_5", sus: "resources/1_5.png", aLMargin: 234, aTMargin: 348, imaColor: "green", imaOpacity: 0.5, armyNum: "7"})
            gameManager.setLand("1_5", "7", "green")

            listmodel.append({name: "1_6", sus: "resources/1_6.png", aLMargin: 303, aTMargin: 296, imaColor: "green", imaOpacity: 0.5, armyNum: "1"})
            gameManager.setLand("1_6", "1", "green")
            listmodel.append({name: "1_7", sus: "resources/1_7.png", aLMargin: 285, aTMargin: 358, imaColor: "red", imaOpacity: 0.5, armyNum: "13"})
            gameManager.setLand("1_7","13","red")

            playerTurn = true;
            turn.visible = true;
            placement = true;
            endTurn.visible = true;
            placementArmy.visible = true;
            startGame.visible = false
        }
    }

    Button { //Кнопка передачи хода
        visible: false
        id: endTurn
        text: "End Turn"
        font.pixelSize: 20
        width: 150
        height: 30
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked:
        {
            console.log()
            if (placementArmy.text == "0")
            {
                placementArmy.visible = true;
                placementArmy.text = "3" //При захвате страны цифра для определённого игрока будет меняться, поэтому надо реализовать в С++
                placement = !placement

                playerTurn = !playerTurn
                turn.visible = true;
                if (playerTurn)
                {
                    turn.text = "Green Turn"
                    turn.color = "green"
                }
                else
                {
                    turn.text = "Red Turn"
                    turn.color = "red"
                }
            }
        }
    }
}
