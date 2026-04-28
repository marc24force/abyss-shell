pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
	id: root

	property string xdg_data_home: Quickshell.env("XDG_DATA_HOME") != null ? Quickshell.env("XDG_DATA_HOME") : Quickshell.env("HOME") + "/.local/share"
	property string xdg_config_home: Quickshell.env("XDG_CONFIG_HOME") != null ? Quickshell.env("XDG_CONFIG_HOME") : Quickshell.env("HOME") + "/.config"
	property string xdg_cache_home: Quickshell.env("XDG_CACHE_HOME") != null ? Quickshell.env("XDG_CACHE_HOME") : Quickshell.env("HOME") + "/.cache"

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

	function expandIconPath(str) {
		var file = Quickshell.shellDir + "/assets/icons/" + str + ".svg"
		if (fileExists(file)) return Qt.resolvedUrl(file)
		file = Quickshell.shellDir + "/assets/icons/" + str + ".png"
		if (fileExists(file)) return Qt.resolvedUrl(file)
		file = str
		if (fileExists(file)) return file
		return Quickshell.iconPath(str)
	}

	function expandThemePath(str) {
		var file = xdg_data_home + "/abyss/themes/" + str
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
