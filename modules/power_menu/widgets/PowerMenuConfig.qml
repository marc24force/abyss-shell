pragma Singleton
import QtQuick

Item {
	property int columns: 3

	property var entries: [
		{ icon: "power/power",     text: "Power Off", key: "Q", cmd: ["sudo","poweroff"] },
		{ icon: "power/lock",      text: "Lock",      key: "W", cmd: ["ls"] },
		{ icon: "power/exit",      text: "Exit",      key: "E", cmd: ["niri","msg","action","quit","-s"] },
		{ icon: "power/restart",   text: "Restart",   key: "A", cmd: ["sudo","reboot"] },
		{ icon: "power/sleep",     text: "Sleep",     key: "S", cmd: ["sudo","zzz"] },
		{ icon: "power/hibernate", text: "Hibernate", key: "D", cmd: ["sudo","zzz","-Z"] }
	]

	property var keys: entries.map(function(item) { return item.key })

	property int rows: entries.length / columns
}
