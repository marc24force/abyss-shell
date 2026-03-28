import QtQuick
import QtQuick.Layouts
import qs.services

Item {
    id: root
    Layout.alignment: Qt.AlignHCenter
    width: logo.implicitWidth
    height: logo.implicitHeight

    Text {
        id: logo
        anchors.centerIn: parent

	font { family: Theme.font.family; pixelSize: Theme.font.pixelSize * 2}

        text: ""
        color: Theme.cs.inactive
        transformOrigin: Item.Center
    }

    ParallelAnimation {
        id: activeAnim
        running: Niri.activeScreenName === bar.screen.name
        loops: Animation.Infinite

        SequentialAnimation {
            ColorAnimation { target: logo; property: "color"; to: Theme.cs.inactive; duration: 900 }
            ColorAnimation { target: logo; property: "color"; to: Theme.accent; duration: 900 }
	    PauseAnimation { duration: 500 }
        }

        NumberAnimation {
            target: logo
            property: "rotation"
            from: 0
            to: 360
            duration: 3600
        }

        onRunningChanged: {
            if (!running) {
                logo.color = Theme.cs.inactive
                logo.rotation = 0
            }
        }
    }
}
