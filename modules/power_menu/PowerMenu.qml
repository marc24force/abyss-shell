import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.widgets
import "widgets"

PopupWidget {
	id: root

	name: "power"
	anchor: "center"

	// Menus are not really modal windows, however for simplicity
	// abyss-shell will treat them as such. They will still be 
	// dismissed by pressing escape or clicking outside the widget.
	modal: true

	// This is the menu widget, it is declared as a component to
	// reduce memory consumption as the widget will be active for
	// a short period and doesn't need to be constantly loaded.
	widget: Component {
		Item {
			id: widget

			// Margins arround the displayed elements, 
			// required to avoid cropping when performing
			// the invalid input animation.
			property int margins: 40
			implicitWidth: layout.implicitWidth + margins
			implicitHeight: layout.implicitHeight + margins

			// The main component is a keyboard like layout
			// but only for the left side.
			SteppedLayout {
				id: layout
				anchors.centerIn: parent
				spacing: 10
				rows: PowerMenuConfig.rows

				model: PowerMenuConfig.entries
				delegate: MenuButton {
					required property var modelData

					icon: modelData.icon
					text: modelData.text
					key: modelData.key
					cmd: modelData.cmd
				}
			}

			// Handle the cancel menu event, all other events
			// are managed by each button.
			Connections {
				target: MenuEvents
				function onCanceled() {hide()}
			}

		}
	}
	

	/* Everything below should go inside the widget Item once this is done,
	 * remove also onCanceled and onConfirmed connections from MenuKeys.qml */

	 // A listener for menu keys. Emits MenuEvents depending
	 // on the key-presses.
	 MenuKeys { 
		 list: PowerMenuConfig.keys
	 }

}
