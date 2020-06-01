import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import Mechanics 1.0

Window {
    visible: true
    width: 1200
    height: 640
    title: "Conquest"

    property string activeLand
    property bool lastResult
    property int lastSurvivors

    Mechanics {
        id: mech
        onFighting: {
            lastResult = result
            lastSurvivors = survivorArmy
        }
    }

    Image {
        id: myMap
        width: parent.width
        height: parent.height
        source: "resources/MyMap.png"

        Image {
            id: land1_1
            source: "resources/1_1.png"

            property var nearLands: ["land1_2", "land1_3"]

            objectName: "land1_1"

            anchors.left: parent.left
            anchors.leftMargin: 113
            anchors.top: parent.top
            anchors.topMargin: 239

            ColorOverlay {
                id: land1_1_overlay
                anchors.fill: land1_1
                        source: land1_1
                        color: "red"
                        opacity: 0.5
            }

            Text {
                id: land1_1_army
                text: qsTr("2")
                font.pixelSize: 24
                anchors.centerIn: parent

                MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(activeLand == "")
                            {
                            land1_1_overlay.opacity = 1
                            activeLand = "land1_1"
                            }

                            else if (activeLand == "land1_1")
                            {
                                land1_1_overlay.opacity = 0.5
                                activeLand = ""
                            }

                            else if (activeLand !== "land1_1")
                            {
                                for(var i = 0; i < land1_1.nearLands.length; ++i)
                                {
                                    console.log(land1_1.nearLands[i])
                                    if(land1_1.nearLands[i] === activeLand)
                                    {
                                        mech.fight(2,10) //Обращения к текстовым полям с армиями (?)
                                        if (lastResult)
                                        {
                                            land1_3_army.text = "" //Обращение к текстовому полю активной земли (?)
                                            land1_1_army.text = lastSurvivors.toString()
                                            land1_1_overlay.color = "green" //Обращение к цвету активной земли (?)
                                        }
                                        else
                                        {
                                            Land1_3_army.text = lastSurvivors //Обращение к текстовому полю активной земли (?)
                                        }
                                        activeLand = ""
                                        land1_3_overlay.opacity = 0.5 //Обращение к цвету активной земли (?)
                                    }
                                }
                            }
                        }
                    }
            }


        }

        Image {
            id: land1_2
            source: "resources/1_2.png"

            objectName: "land1_2"

            anchors.left: parent.left
            anchors.leftMargin: 194
            anchors.top: parent.top
            anchors.topMargin: 200

            ColorOverlay {
                anchors.fill: land1_2
                        source: land1_2
                        color: "yellow"
                        opacity: 0.5
            }

        }

        Image {
            id: land1_3
            source: "resources/1_3.png"
            objectName: "land1_3"
            property var nearLands: ["land1_1", "land1_2", "land1_4", "land1_5"]

            anchors.left: parent.left
            anchors.leftMargin: 195
            anchors.top: parent.top
            anchors.topMargin: 285

            ColorOverlay {
                id: land1_3_overlay
                anchors.fill: land1_3
                        source: land1_3
                        color: "green"
                        opacity: 0.5
            }


            Text {
                id: land1_3_army
                text: qsTr("10")
                font.pixelSize: 24
                anchors.centerIn: parent

                MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(activeLand == "")
                            {
                            land1_3_overlay.opacity = 1
                            activeLand = "land1_3"
                            }

                            else if (activeLand == "land1_3")
                            {
                                land1_3_overlay.opacity = 0.5
                                activeLand = ""
                            }

                            else if (activeLand !== "land1_3")
                            {
                                for(var i = 0; i < land1_3.nearLands.length; ++i)
                                {
                                    console.log(land1_3.nearLands[i])
                                    if(land1_3.nearLands[i] === activeLand)
                                    {
                                        mech.fight(2,10) //Обращения к текстовым полям с армиями (?)
                                        if (lastResult)
                                        {
                                            land1_1_army.text = "" //Обращение к текстовому полю активной земли (?)
                                            land1_3_army.text = lastSurvivors.toString()
                                            land1_3_overlay.color = "red" //Обращение к цвету активной земли (?)
                                        }
                                        else
                                        {
                                            Land1_1_army.text = lastSurvivors //Обращение к текстовому полю активной земли (?)
                                        }
                                        activeLand = ""
                                        land1_1_overlay.opacity = 0.5 //Обращение к цвету активной земли (?)
                                    }
                                }

                            }
                            console.log(activeLand)
                        }
                    }
            }

        }

        Image {
            id: land1_4
            source: "resources/1_4.png"
            anchors.left: parent.left
            anchors.leftMargin: 248
            anchors.top: parent.top
            anchors.topMargin: 283

            ColorOverlay {
                anchors.fill: land1_4
                        source: land1_4
                        color: "blue"
                        opacity: 0.5
            }

        }

        Image {
            id: land1_5
            source: "resources/1_5.png"
            anchors.left: parent.left
            anchors.leftMargin: 234
            anchors.top: parent.top
            anchors.topMargin: 348

            ColorOverlay {
                anchors.fill: land1_5
                        source: land1_5
                        color: "pink"
                        opacity: 0.5
            }

        }

        Image {
            id: land1_6
            source: "resources/1_6.png"
            anchors.left: parent.left
            anchors.leftMargin: 303
            anchors.top: parent.top
            anchors.topMargin: 296

            ColorOverlay {
                anchors.fill: land1_6
                        source: land1_6
                        color: "brown"
                        opacity: 0.5
            }

        }

        Image {
            id: land1_7
            source: "resources/1_7.png"
            anchors.left: parent.left
            anchors.leftMargin: 285
            anchors.top: parent.top
            anchors.topMargin: 358

            ColorOverlay {
                anchors.fill: land1_7
                        source: land1_7
                        color: "purple"
                        opacity: 0.5
            }

        }
    }
}
