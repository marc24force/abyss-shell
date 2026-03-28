pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
	id: root

	Component {
		id: checker_component
		FileView {
			path: ""
			printErrors: false
			property int code: 1
			onLoadFailed: { code = 1; path = "" }
			onLoaded: { code = 0; path = "" }
		}
	}

	// Synchronous-looking fileExists function
	function fileExists(file) {
		var checker = checker_component.createObject(root)
		if (!checker) {
			console.error("Failed to create FileView in fileExists()")
			return false
		}
		checker.path = file
		checker.waitForJob()
		var exists = (checker.code === 0)
		checker.destroy()
		return exists
	}

	function expandThemePath(str) {
		var file = Quickshell.env("HOME") + "/.local/share/abyss/themes/" + str
		if (fileExists(file)) return file
		file = "/usr/local/share/abyss/themes/" + str
		if (fileExists(file)) return file
		file = "/usr/share/abyss/themes/" + str
		if (fileExists(file)) return file
		file = Quickshell.shellDir + "/assets/themes/" + str
		if (fileExists(file)) return file
		return str
	}
}
