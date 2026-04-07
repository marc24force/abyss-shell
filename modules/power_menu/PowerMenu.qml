import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.widgets

PopupWidget {
	id: root

	name: "power"
	anchor: "center"

	// Menus are not really modal windows, however for simplicity
	// abyss-shell will treat them as such. They will still be 
	// dismissed by pressing escape or clicking outside the widget.
	modal: true

	widget: Component {
		Item {
			id: widget
			property int margins: 40

			implicitWidth: layout.implicitWidth + margins
			implicitHeight: layout.implicitHeight + margins

			SteppedLayout {
				id: layout
				anchors.centerIn: parent
				spacing: 10
				rows: 2

				model: root.model
				delegate: MenuButton {
					required property var modelData

					icon: modelData.icon
					text: modelData.text
					key: modelData.key

					hint: root.hint
					error: root.error
					selection: root.selection
					pressed: root.pressed

				}
			}

			SequentialAnimation {
				id: shakeAnim
				running: root.error
				loops: 1
				NumberAnimation { target: widget; property: "y"; to: widget.y - 10; duration: 100; easing.type: Easing.InOutQuad }
				NumberAnimation { target: widget; property: "y"; to: widget.y + 10; duration: 100; easing.type: Easing.InOutQuad }
				NumberAnimation { target: widget; property: "y"; to: widget.y - 10; duration: 100; easing.type: Easing.InOutQuad }
				NumberAnimation { target: widget; property: "y"; to: widget.y; duration: 100; easing.type: Easing.InOutQuad }
				PauseAnimation {duration: 200}

				onStopped: root.error = false
			}

			Connections {
				target: MenuEvents
				function onSelected(key) {
					selection = key
				}
				function onConfirmed(key) {
					pressed = key
					var obj = model.find(function(item) { return item.key === key })
					Quickshell.execDetached(obj.cmd.split(" "))
					hide()
				}

				function onCanceled() {hide()}
				function onHelp() {root.hint = true}
				function onError() {root.error = true}
			}

			Component.onCompleted: {
				root.selection = ""
				root.pressed = ""
				root.hint = ""
				root.error = false
				shakeAnim.stop()
			}
		}
	}

	/* Everything below should go inside the widget Item*/
	property bool hint: false
	property string selection: ""
	property string pressed: ""
	property bool error: false

	property var model: [
		{ icon: "", text: "Power Off", key: "Q", cmd: "sudo poweroff" },
		{ icon: "󰌾", text: "Lock",      key: "W", cmd: "ls" },
		{ icon: "󰈆", text: "Exit",      key: "E", cmd: "niri msg action quit -s" },
		{ icon: "󰜉", text: "Restart",   key: "A", cmd: "sudo reboot" },
		{ icon: "󰤄", text: "Sleep",     key: "S", cmd: "sudo zzz" },
		{ icon: "󰜗", text: "Hibernate", key: "D", cmd: "sudo zzz -Z" }
	]

	MouseArea {
		id: mouseCancelArea
		onClicked: MenuEvents.canceled()
	}	



	MenuKeys { 
		id: keys
		selection: root.selection
		list: model.map(function(item) { return item.key; })

	}

	Timer {
		id: hint_timer
		interval: 5000
		running: root.hint
		repeat: false
		onTriggered: hint = false
	}
}
