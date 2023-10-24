import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtCore
import Qt.cropTool.cropHandlerSingleton 1.0

Flickable {
    id:flickArea

    property point startPosition: Qt.point(0, 0)
    property double zoomFactor: 1.0

    anchors.fill: parent
    contentWidth: Math.max(image.width * zoomFactor, flickArea.width)
    contentHeight: Math.max(image.height * zoomFactor, flickArea.height)

    Image {
        id: image
        source: CropHandler.originalImageUrl
        scale: zoomFactor
        anchors.centerIn: parent
        transformOrigin: Item.Center

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
        anchors.fill: parent
        onWheel: (wheel) => {
            if (wheel.modifiers & Qt.ControlModifier) {
                zoomFactor += wheel.angleDelta.y / 1200
            }
        }

        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                console.log("mouse pressed")
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
        implicitHeight: 30
        implicitWidth: 100
        visible: false

        Button {
            anchors.fill: parent
            text: "Save?"
            onClicked: {
                CropHandler.cropImage(Qt.rect(markRectangle.x, markRectangle.y, markRectangle.width, markRectangle.height))
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
