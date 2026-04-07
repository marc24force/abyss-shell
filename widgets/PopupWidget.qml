import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.services

Loader {
	id: root
	
	// This is the panel where to load the popup
	required property QtObject window

	// This is the anchor where the popup will be Valid values are (top, bottom,
	// left, right, center, {top,bottom}-{left,right})
	required property string anchor

	// This is the widget that we will be showing in the popup, needs to be passed
	// as a component.
	required property Component widget

	// A unique name to identify the popup in the window data list
	required property string name

	// Set if the popup requires input. This is agressively getting exclusive
	// keyboard focus, not fully tested and might break
	property bool modal: false

	// Loader to save memory, the object is only created when active is set,
	// so it should start deactivated. When activated should give the window
	// exclusive focus if modal is enabled. Also focus should be removed at
	// destruction
	
	active: false

	// Popup window containing the widget. It is managed by the loader
	// so it is always set to visible, the position is derived from 
	// the anchor.
	sourceComponent: PopupWindow {
		id: popup
		visible: true
		anchor.window: root.window
		color: "transparent"

		// Adding the window width into the computation messes
		// with the resize, so instead we will adjust the gravity.
		anchor.rect.x: {
			if (root.anchor.includes("left")) return 0
			if (root.anchor.includes("right")) return root.window.width
			return root.window.width / 2
		}
		anchor.rect.y: {
			if (root.anchor.includes("top")) return 0;
			if (root.anchor.includes("bottom")) return root.window.height
			return root.window.height / 2
		}

		// Gravity always points towards the center. No need to do 
		// anything for center
		anchor.gravity: {
			var ret = Edges.None
			if (root.anchor.includes("top")) ret |= Edges.Bottom
			if (root.anchor.includes("left")) ret |= Edges.Right
			if (root.anchor.includes("right")) ret |= Edges.Left
			if (root.anchor.includes("bottom")) ret |= Edges.Top
			return ret
		}

		// Loader responsible for managing the widget
		Loader {
			id: content
			anchors.centerIn: parent
			sourceComponent: root.widget
		}
		Item {
			anchors.fill: parent
			focus: true
			Keys.onPressed: (event)=> {
				if (event.key == Qt.Key_Left) {
					console.log("move left");
					event.accepted = true;
				}
			}
		}
		
		// If modal we will configure the window so it has exclusive focus.
		// Also, add a dimmed background effect to give focus to the widget.
		// And set the mask so it blocks mouse clicks.
		Component.onCompleted: {
			if (!modal) return
			window.color = Qt.alpha(Theme.cs.background, 0.5)
			window.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive
			window.mask.intersection = Intersection.Xor
			window.mask.height = window.height
		}

		// Undo the construction changes performed to the window.
		Component.onDestruction: {
			if (!modal) return
			window.color = "transparent"
			window.WlrLayershell.keyboardFocus = WlrLayershell.None
			window.mask.intersection = Intersection.Combine
		}

		// Adds a wrong margin if to close to the screen edge so 
		// needs to be null
		anchor.adjustment: PopupAdjustment.None

		// Set the size of the window, if unset it will use the implicit size
		// of the created item, if not valid it will default to 100x100
		implicitWidth: root.implicitWidth ? root.implicitWidth : (content.item.implicitWidth ? content.item.implicitWidth : 100)
		implicitHeight: root.implicitHeight ? root.implicitHeight : (content.item.implicitHeight ? content.item.implicitHeight : 100)
	}
	
	// Item should grab focus when active if is in modal mode
	focus: root.active && modal

	// General functions to show, hide or toggle
	// the popup. 
	function show() { root.active = true; hide_timer.stop() }
	function hide() { root.active = false; }
	function toggle() { if (root.active) hide(); else show() }

	// Function to show the popup for a fixed
	// amount of time in ms.
	function showFor(ms: int) {
		show()
		hide_timer.interval = ms
		hide_timer.restart()
	}

	// Timer utility to hide popup after a time
	Timer {
		id: hide_timer
		running: false
		repeat: false
		onTriggered: hide()
	}
}
