pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
	id: root

	FileView {
		id: checker
		path: ""
		printErrors: false
		property int code: 1
		onLoadFailed: { code = 1; path = "" }
		onLoaded: { code = 0; path = "" }
	}

	function fileExists(file: string) : bool {
		checker.path = file
		checker.waitForJob()
		return (checker.code === 0)
	}

	function expandThemePath(str: string) : string { 
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
