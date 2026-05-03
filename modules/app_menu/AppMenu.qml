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

			property var entries_left: entries.slice(0, Math.ceil(entries.length / 2))
			property var entries_right: entries.slice(Math.ceil(entries.length / 2))

			RowLayout {
				id: layout
				anchors.centerIn: parent
				spacing: 100
				SteppedLayout {
					spacing: 10
					rows: AppMenuConfig.gridConfig[entries.length].rows

					model: entries_left
					delegate: button
				}

				SteppedLayout {
					spacing: 10
					rows: AppMenuConfig.gridConfig[entries.length].rows

					stepDirection: stepNegative

					model: entries_right
					delegate: button
				}
			}

			// When menu is opened we reset the last selection.
			// This is required because MenuKeys not being inside
			// the widget.
			Component.onCompleted: {
				MenuEvents.selected("")
			}

			// Handle the cancel menu event, all other events
			// are managed by each button.
			Connections {
				target: MenuEvents
				function onCanceled() { hide() }
				function onExecuted(text) { AppHistory.add(text) }
			}

		}
	}

	/* Everything below should go inside the widget Item once this is done,
	 * remove also onCanceled and onConfirmed connections from MenuKeys.qml */


	 property string search: ""

	 // List of applications processed to be passed as modelData. The list
	 // performs a search through name,
	 property var raw_apps: {  
		 const apps = DesktopEntries.applications.values;  
		 const searchLower = search.toLowerCase();  

		 return apps.filter(app =>   
		 	app.name.toLowerCase().includes(searchLower) ||  
		 	app.genericName.toLowerCase().includes(searchLower) ||  
		 	app.categories.some(category => category.toLowerCase().includes(searchLower))  
		);  
	 }
	 
	 // Size of the app list, this is truncated at certain sizes for correct
	 // visualization of the menu.
	 property int apps_size: AppMenuConfig.validSizes.find(size => size <= raw_apps.length) || 0

	 // App list is sorted by adding first the entries in the history by
	 // preserving the original order, and then the rest.
	 property var sorted_apps: {  
		 const historyList = AppHistory.get();  
		 const recentApps = raw_apps.filter(item => historyList.includes(item.name));  
		 const otherApps = raw_apps.filter(item => !historyList.includes(item.name));  

		 // Sort recent apps by their position in history (most recent first)  
		 recentApps.sort((a, b) => {  
			 const aIndex = historyList.indexOf(a.name);  
			 const bIndex = historyList.indexOf(b.name);  
			 return aIndex - bIndex; // Lower index = more recent  
		 });  

		 return [].concat(recentApps, otherApps);  
	 };

	 // The actual entry with the icon, text, key and command, mapped to the list of keys.
	 property var entries: sorted_apps.slice(0, apps_size)
	 .map((entry, index) => {
		 const idx = index % (apps_size / 2)
		 const row = Math.floor(idx / AppMenuConfig.gridConfig[apps_size].cols);
		 const col = idx % AppMenuConfig.gridConfig[apps_size].cols;
		 const key = (index < apps_size / 2) ? AppMenuConfig.leftKeys[row * 4 + col] || '' 
		                                     : AppMenuConfig.rightKeys[row * 4 + col] || '';
		 return {
			 icon: entry.icon,
			 text: entry.name,
			 key: key,
			 cmd: entry.runInTerminal ? ["foot"].concat(entry.command)
			                          : entry.command
		 };
	 });


	 // A listener for menu keys. Emits MenuEvents depending
	 // on the key-presses.
	 MenuKeys { 
		 list: entries.map(function(item) { return item.key })
	 }

 }
