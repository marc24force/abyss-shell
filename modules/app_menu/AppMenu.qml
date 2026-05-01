import Quickshell

import QtQuick
import QtQuick.Layouts

import qs.services
import qs.widgets
import "widgets"

PopupWidget {
	id: root

	name: "apps"
	anchor: "center"

	// Menus are not really modal windows, however for simplicity
	// abyss-shell will treat them as such. They will still be 
	// dismissed by pressing escape or clicking outside the widget.
	modal: true

	// This is the app widget, it is declared as a component to
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

			property var button: Component {
				MenuButton {
					required property var modelData

					icon_color: state != "" ? "transparent" : Theme.cs.inactive
					icon_light: state != "" ? 0 : (Theme.cs === Theme.cs_light ? 0.6 : 0.2)

					icon: modelData.icon
					text: modelData.text
					key: modelData.key
					cmd: modelData.cmd
				}
			}

			RowLayout {
				id: layout
				anchors.centerIn: parent
				spacing: 100
				SteppedLayout {
					spacing: 10
					rows: 2

					model: entries.filter((entry, index) => index % 6 < 3)
					delegate: button
				}

				SteppedLayout {
					spacing: 10
					rows: 2

					stepDirection: SteppedLayout.stepNegative

					model: entries.filter((entry, index) => index % 6 >= 3)
					delegate: button
				}
			}

			// When menu is opened we reset the last selection.
			// This is required because MenuKeys not being inside
			// the widget.
			Component.onCompleted: MenuEvents.selected("")

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

	 // List of applications processed to be passed as modelData. The list
	 // is sorted by app name before a key is assigned to it.
	 property var entries: DesktopEntries.applications.values
	 .slice()
	 .sort((a, b) => {
		 const textA = a.name.toLowerCase();
		 const textB = b.name.toLowerCase();
		 if (textA < textB) return -1;
		 if (textA > textB) return 1;
		 return 0;
	 })
	 .map((entry, index) => ({
		 icon: entry.icon,
		 text: entry.name,
		 key: AppMenuConfig.keys[index] || '',
		 cmd: entry.runInTerminal ? ["foot"].concat(entry.command)
		 : entry.command
	 }));


	 // A listener for menu keys. Emits MenuEvents depending
	 // on the key-presses.
	 MenuKeys { 
		 list: entries.map(function(item) { return item.key })
	 }

 }
