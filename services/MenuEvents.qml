pragma Singleton

import QtQuick

QtObject {
	// Signal emited when selecting a key.
	signal selected(string key)

	// Signal emited when confirming the selection, this can be 
	// either by pressing the same key or a enter with a valid 
	// selection.
	signal confirmed(string key)

	// Signal emited when canceling the menu, this is emited 
	// when the Escape key is pressed.
	signal canceled()

	// Signal emited when an invalid key is pressed.
	signal error()

	// Signal emited when the helpKey is pressed.
	signal help()

}
