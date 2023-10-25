import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.cropTool.cropHandlerSingleton 1.0
import QtQuick.Shapes 1.6
import Components 1.0

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Crop tool")

    readonly property int bottomPanelHeightMax: 200
    readonly property int bottomPanelHeightMin: 0

    Rectangle {
        anchors.fill: parent
        z: 0
        color: "#5E5E5E"
    }

    Label {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        text: "No Image"
        font.pixelSize: 30
        font.family: "OpenSans"
        font.weight: 700
    }

    SelectableArea {
        id: selectableArea
    }

    BottomPanel {
        id: bottomPanel
        z: 10
        anchors {
                  bottom: parent.bottom
                  left: parent.left
                  right: parent.right
        }
        visible:true
        implicitHeight: bottomPanelHeightMin

        Rectangle {
            anchors.fill:parent
            gradient: LinearGradient {
                GradientStop{position: 0.3; color: "#3C3C3C"}
                GradientStop{position: 0.7; color: "#323232"}
                GradientStop{position: 1.0; color: "#171717"}
            }
            border.color: "#000000"
        }

        RowLayout {
            spacing: 10
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            Button {
                onClicked: {
                    fileDialog.open()
                }
                visible: bottomPanel.height === bottomPanelHeightMax ? true : false

                background: Rectangle {
                    gradient: LinearGradient {
                        GradientStop { position: 0.0; color: "#5E5E5E" }
                        GradientStop { position: 0.3; color: "#585858" }
                        GradientStop { position: 0.7; color: "#4E4E4E" }
                        GradientStop { position: 1.0; color: "#474747" }
                    }
                    radius: 6
                    border.color: "#2B2B2B"
                }
                contentItem: Text {
                    text: "Load image"
                    font.pixelSize: 14
                    font.family: "OpenSans"
                    font.weight: 500
                    color: "black"
                }
            }
            Label {
                id: fileUrlLabel
                text: "{Empty}"
                font.pixelSize: 14
                font.family: "OpenSans"
                font.weight: 500
                color: "black"
                visible: bottomPanel.height === bottomPanelHeightMax ? true : false
            }
        }
    }

    Button {
        id: openBottomPanelButton
        contentItem: Text {
            color: "black"
            text:bottomPanel.height === bottomPanelHeightMax ? "Close Panel" : "Open Panel"
        }
        anchors {
            bottom: bottomPanel.top
            horizontalCenter: parent.horizontalCenter
        }
        onClicked: {
            if (!showAnimation.finished()) {
                showAnimation.start();
            }
        }

        background: Rectangle {
            gradient: LinearGradient {
                GradientStop { position: 0.0; color: "#5E5E5E" }
                GradientStop { position: 0.3; color: "#585858" }
                GradientStop { position: 0.7; color: "#4E4E4E" }
                GradientStop { position: 1.0; color: "#474747" }
            }
            radius: 6
            border.color: "#2B2B2B"
        }
    }

    FileDialog {
        id: fileDialog
        title: "please choose a file"
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        onAccepted: {
            CropHandler.openNewImage(selectedFile)
            fileUrlLabel.text = selectedFile
        }
    }

    NumberAnimation {
        id: showAnimation
        easing.type: Easing.InOutBounce;
        properties: "implicitHeight";
        target:bottomPanel
        to: bottomPanel.implicitHeight === bottomPanelHeightMin
            ? bottomPanelHeightMax : bottomPanelHeightMin
        duration: 1000;
    }
}
