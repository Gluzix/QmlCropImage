import QtCore
import QtQuick
import QtQuick.Window
import QtQuick.Dialogs
import QtQuick.Controls
import Components 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Crop tool")

    property string pathToFile: ""

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
        visible:false

        Button {
            anchors {
                top: parent.top
                left: parent.left
            }

            onClicked: {
                fileDialog.open()
            }

            text: "Load image"
        }
    }

    Button {
        id: openBottomPanelButton
        text: "Open Panel"
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        visible: !bottomPanel.visible
        onClicked: {
            bottomPanel.visible = true
        }
    }

    Label {
        id: urlLabel
        width: 200
        height: 30
        visible:true
        text: "test label"
        color: "#000000"
    }


    FileDialog {
        id: fileDialog
        title: "please choose a file"
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        onAccepted: {
            pathToFile = selectedFile
            urlLabel.text = pathToFile
        }
        onRejected: {
            urlLabel.text = "Rejected"
        }
    }

}
