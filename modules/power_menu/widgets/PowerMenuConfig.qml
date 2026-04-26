pragma Singleton
import QtQuick

Item {
	property int columns: 3

	property var entries: [
		{ icon: "", text: "Power Off", key: "Q", cmd: "sudo poweroff" },
		{ icon: "󰌾", text: "Lock",      key: "W", cmd: "ls" },
		{ icon: "󰈆", text: "Exit",      key: "E", cmd: "niri msg action quit -s" },
		{ icon: "󰜉", text: "Restart",   key: "A", cmd: "sudo reboot" },
		{ icon: "󰤄", text: "Sleep",     key: "S", cmd: "sudo zzz" },
		{ icon: "󰜗", text: "Hibernate", key: "D", cmd: "sudo zzz -Z" }
	]

	property var keys: entries.map(function(item) { return item.key })

	property int rows: entries.length / columns
}
