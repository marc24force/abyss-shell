import QtQuick
import qs.services


// This is an animation for when the user performs an
// input action which is not valid for the current 
// focused window.
SequentialAnimation {
	id: root

	required property var target

	ColorAnimation { target: root.target; property: "shadow_color"; to: Theme.cs.critical; duration: 10}
	NumberAnimation { target: root.target; property: "y"; to: target.y - 10; duration: 100; easing.type: Easing.InOutQuad }
	NumberAnimation { target: root.target; property: "y"; to: target.y + 10; duration: 100; easing.type: Easing.InOutQuad }
	NumberAnimation { target: root.target; property: "y"; to: target.y - 10; duration: 100; easing.type: Easing.InOutQuad }
	NumberAnimation { target: root.target; property: "y"; to: target.y; duration: 100; easing.type: Easing.InOutQuad }
	PauseAnimation {duration: 200}
	ColorAnimation { target: root.target; property: "shadow_color"; to: Theme.cs.shadow; duration: 0}
}
