import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.widgets
import qs.services

ShadowRectangle {
	id: root

	// Required properties that should be passed to the widget,
	// they define the icon and text for the button and the 
	// quick action key to start it.
	required property string icon
	required property string text
	required property string key
	required property string cmd

	// The implicit width and height of the button, varying 
	// depending on the contents, but with a minimum size of 
	// 100.
	implicitWidth: (layout.width > 100) ? layout.width : 100
	implicitHeight: (layout.height > 100) ? layout.height : 100

	// Properties that change depending on the state.
	property color text_color: state != "" ? Theme.cs.foreground : Theme.cs.inactive
	color: state === "confirmed" ? Theme.cs.inactive : Theme.cs.background

	property int icon_size: Theme.getFontSize() * 2.5
	property int text_size: Theme.getFontSize() * 0.8
	property int hint_size: Theme.getFontSize() * 0.75

	// This is the main button layout which consists of the 
	// icon and name.
	ColumnLayout {
		id: layout
		anchors.centerIn: parent
		spacing: 10


		ColorizedIcon {  
			Layout.alignment: Qt.AlignCenter
			implicitWidth: icon_size  
			implicitHeight: icon_size  
			source: FileSystem.expandIconPath(root.icon)  
			tint: root.text_color  
		}  

		Text {
			text: root.text
			font.family: Theme.getFontSans()
			font.pixelSize: text_size
			color: root.text_color
			Layout.alignment: Qt.AlignCenter
		}
	}

	// Hint text. When hint is set the color changes to foreground and
	// turns bold. Only lasts until hint_timer triggers.
	Text {
		id: hint_text
		text: root.key
		color: hint.running ? Theme.cs.foreground : Theme.cs.inactive
		font.family: Theme.getFontSans()
		font.bold: hint.running
		font.pixelSize: hint_size
		x: (parent.width - width) * 0.90 
		y: 10
	}
	
	// Timer representing the hint state, when the timer is active 
	// tells if the hint is enabled or not.
	Timer {
		id: hint;
		interval: 5000
	}

	// Similar to hint, the error state is managed by the error
	// animation.
	InvalidInputAnimation {
		id: error
		target: root
	}

	// This is a button so it captures mouse actions and issues the
	// corresponding MenuEvents.
	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		anchors.margins: width * 0.10
		onExited: MenuEvents.selected("")
		onEntered: MenuEvents.selected(key)
		onClicked: MenuEvents.confirmed(key)
	}	
	
	// Handle incoming MenuEvents.
	Connections {
		target: MenuEvents

		// Only enabled if not handling an error.
		enabled: !error.running

		// If the selected key is itself, change the state to
		// selected, but go to idle if not.
		function onSelected(key) {
			if (key === root.key) state = "selected"
			else state = ""
		}

		// If the confirmed key is itself, change the state to
		// confirmed, but go to idle if not.
		function onConfirmed(key) {
			if (key === root.key) state = "confirmed"
			else state = ""
		}

		// Start error animation when receiving the signal.
		function onError() { error.start() }

		// Start hint when receiving a help signal.
		function onHelp() { hint.start() }
	}

	// Kill switch to execute the command. It gives a grace period
	// to have a visual feedback of the confirmed action.
	// Menu is canceled afterwards as the action is emmited.
	Timer {
		running: state === "confirmed"
		interval: 200
		onTriggered: {
			Quickshell.execDetached(root.cmd.split(" "))
			MenuEvents.canceled()
		}
	}


}
