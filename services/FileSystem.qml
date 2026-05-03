pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
	id: root

	Component {
		id: checker_component
		FileView {
			printErrors: false

			function check(filePath) {
				this.path = filePath
				this.waitForJob()
				return this.loaded
			}
		}
	}

	// Synchronous-looking fileExists function
	function fileExists(file) {
		var checker = checker_component.createObject(root)
		if (!checker) {
			console.error("Failed to create FileView in fileExists()")
			return false
		}
		return checker.check(file)
	}

	function expandIconPath(str) {
		var file = Quickshell.shellDir + "/assets/icons/" + str + ".svg"
		if (fileExists(file)) return Qt.resolvedUrl(file)
		file = Quickshell.shellDir + "/assets/icons/" + str + ".png"
		if (fileExists(file)) return Qt.resolvedUrl(file)
		file = str
		if (fileExists(file)) return file
		file = Quickshell.iconPath(str, true)
		var fallback = str.slice(str.lastIndexOf('/') + 1).charAt(0).toUpperCase()
		return file ? file : fallback


	}

	function expandThemePath(str) {
		var file = Quickshell.dataPath("themes/" + str)
		if (fileExists(file)) return file
		file = "/usr/local/share/abyss/themes/" + str
		if (fileExists(file)) return file
		file = "/usr/share/abyss/themes/" + str
		if (fileExists(file)) return file
		file = Quickshell.shellPath("/assets/themes/" + str)
		if (fileExists(file)) return file
		return str
	}
}
