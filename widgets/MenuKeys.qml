import Quickshell
import QtQuick

import qs.services
// This item helps manage keyboard control of menus, it emits a signal
// when an item is selected or confirmed. It can also emit an error if
// an invalid key is pressed.
Item {
	// Whe should get focus if the parent has focus.
	focus: parent.focus

	// When confirming the keypress we must know which is the 
	// parent current selection key, it must be passed here.
	required property string selection

	// List of valid keys to select from.
	required property var list

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
				// but send error signal. Early return to
				// avoid accpeting the input.
				if (key != "") MenuEvents.error()
				return
			}
		}
		event.accepted = true
	}

}
