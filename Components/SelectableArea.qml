import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtCore
import QtQuick.Shapes 1.6
import Qt.cropTool.cropHandlerSingleton 1.0

Flickable {
    id:flickArea

    property point startPosition: Qt.point(0, 0)
    property double zoomFactor: 1.0
    property bool isImageLoaded: false

    anchors.fill: parent
    contentWidth: Math.max(image.width * zoomFactor, flickArea.width)
    contentHeight: Math.max(image.height * zoomFactor, flickArea.height)

    Image {
        id: image
        source: CropHandler.originalImageUrl
        scale: zoomFactor
        anchors.centerIn: parent
        transformOrigin: Item.Center

        onSourceChanged: {
            saveWindow.visible = false
            markRectangle.width = 0
            markRectangle.height = 0
            isImageLoaded = true
        }

        Rectangle {
            id: markRectangle
            x:0
            y:0
            width:0
            height:0
            color: "#888888CC"
        }
    }

    MouseArea {
        acceptedButtons: {Qt.LeftButton | Qt.RightButton}
        enabled: isImageLoaded
        anchors.fill: parent
        onWheel: (wheel) => {
            if (wheel.modifiers & Qt.ControlModifier) {
                zoomFactor += wheel.angleDelta.y / 1200
            }
        }

        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                var mappedPoint = mapToItem(image, Qt.point(mouseX, mouseY))
                markRectangleMousePressed(mappedPoint.x, mappedPoint.y);
            }
        }

        onMouseXChanged: {
            if (pressedButtons & Qt.RightButton) {
                var mappedPoint = mapToItem(image, Qt.point(mouseX, mouseY))
                markRectangleMouseMovedX(mappedPoint.x);
            }
        }

        onMouseYChanged: {
            if (pressedButtons & Qt.RightButton) {
                var mappedPoint = mapToItem(image, Qt.point(mouseX, mouseY))
                markRectangleMouseMovedY(mappedPoint.y);
            }
        }
        onReleased: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                saveWindow.visible = true
                saveWindow.x = mouseX
                saveWindow.y = mouseY
            }
        }
    }

    Item {
        id: saveWindow
        implicitHeight: 60
        implicitWidth: 200
        visible: false
        Rectangle {
            anchors.fill:parent
            color: "black"
            opacity: 0.3
        }

        Button {
            id: saveWindowButton
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: parent.top
                margins:10
            }
            implicitWidth:100
            implicitHeight:30

            onClicked: {
                CropHandler.cropImage(Qt.rect(markRectangle.x, markRectangle.y, markRectangle.width, markRectangle.height))
            }

            contentItem: Text {
                text: "Save"
                font.family: "OpenSans"
                font.pixelSize: 14
                color: "#000000"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                id: saveWindowButtonBackground
                gradient: LinearGradient {
                    GradientStop{position: 0.0; color:"#6E6E6E"}
                    GradientStop{position: 0.5; color:"#5B5B5B"}
                    GradientStop{position: 1.0; color:"#444444"}
                }
                border.color: saveWindowButton.pressed ? "#D2D2D2" : "#2B2B2B"
                radius: 6
            }
        }
    }

    function markRectangleMousePressed(mouseX, mouseY) {
        startPosition.x = mouseX
        startPosition.y = mouseY
        markRectangle.x = startPosition.x
        markRectangle.y = startPosition.y
    }

    function markRectangleMouseMovedX(mouseX) {
        var difference = mouseX - startPosition.x
        if (difference < 0) {
            markRectangle.x = mouseX
        }
        markRectangle.width = Math.abs(difference)
    }

    function markRectangleMouseMovedY(mouseY) {
        var difference = mouseY - startPosition.y
        if (difference < 0) {
            markRectangle.y = mouseY
        }
        markRectangle.height = Math.abs(difference)
    }

}
