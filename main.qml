import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: 1200
    height: 640
    title: "Conquest"

    Image {
        id: myMap
        width: parent.width
        height: parent.height
        source: "resources/MyMap.png"

        Image {
            id: land1_1
            source: "resources/1_1.png"
            anchors.left: parent.left
            anchors.leftMargin: 113
            anchors.top: parent.top
            anchors.topMargin: 239

            ColorOverlay {
                anchors.fill: land1_1
                        source: land1_1
                        color: "red"
                        opacity: 0.5
            }
        }

        Image {
            id: land1_2
            source: "resources/1_2.png"
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
            anchors.left: parent.left
            anchors.leftMargin: 195
            anchors.top: parent.top
            anchors.topMargin: 285

            ColorOverlay {
                anchors.fill: land1_3
                        source: land1_3
                        color: "green"
                        opacity: 0.5
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
