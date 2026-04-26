import Quickshell
import QtQuick

import qs.services

// This item helps manage keyboard control of menus, it emits a signal
// when an item is selected or confirmed. It can also emit an error if
// an invalid key is pressed or a help signal if the defined helpKey 
// is pressed.
Item {
	// This requires focus
	focus: true

	// List of valid keys to select from.
	required property var list

	// When confirming the keypress we must know which is the 
	// parent current selection key.
	property string selection: ""

	// To configure the helpKey key, by default is '?'.
	property string helpKey: "?"
	
	// Helper function to verify if the key is in the passed 
	// list of objects. Force upper case to match.
	function validKey(list, key) {
		return list.some(item => item.toUpperCase() === key.toUpperCase())
	}

	// We confirm the selection, if no selection is done we 
	// return an error, otherwise confirm it. In this case
	// we do not verify the confirmation.
	Keys.onReturnPressed: {
		if (selection === "") MenuEvents.error()
		else MenuEvents.confirmed(selection)
	}

	// Just emit the canceled signal.
	Keys.onEscapePressed: MenuEvents.canceled()


	Keys.onPressed: (event)=> {
		var key = event.text.toUpperCase()

		// If the helpKey is pressed we send a help signal.
		if (key === helpKey) MenuEvents.help()
		else {
			// Check if the key is in the list, if it is,
			// send a confirmed or selected signal 
			// depending on the current selection.
			if (validKey(list, key)) {
				if (selection === key) MenuEvents.confirmed(key)
				else MenuEvents.selected(key)
			} else {
				// Avoid modifier keys to trigger the error.
				// Send error signal. Early return to
				// avoid accepting the input.
				if (key != "") MenuEvents.error()
				return
			}
		}
		event.accepted = true
	}

	// We monitor the selected event to know which is the current
	// selection. onCanceled and onConfirmed are required due to
	// MenuKeys not being inside the PowerMenu component.
	Connections {
		target: MenuEvents
		function onSelected(key) { selection = key }
		function onCanceled() { selection = "" }
		function onConfirmed(key) { selection = "" }
	}
}
