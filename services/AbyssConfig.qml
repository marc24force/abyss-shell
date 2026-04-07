pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import qs.services

Item {
	id: config

	readonly property var bar: ({
		size: 50,
		anchor: "left",
		margins: ({
			short: 2,
			long: 12
		})
	})

	readonly property var frame: ({
		size: 4,
		radius: 18,
		shadow_strength: 3
	})
}
