pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.widgets
import qs.services

Item {
	id: root

	// Paths
	property string configDir: {
		var xdg = Quickshell.env("XDG_CONFIG_HOME")
		if (!xdg || xdg == "") xdg= Quickshell.env("HOME")+ "/.config"
		return xdg
	}

	readonly property string themeDir: configDir + "/abyss"
	readonly property string themeFile: themeDir + "/theme.json"

	FileView { // Theme file
		id: theme_file
		path: themeFile

		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: {
			if (!json.blockAdapterUpdates) {
				writeAdapter()
				console.info("Updating config theme file")
			}
		}

		blockLoading: true
		blockWrites: true

		onLoadFailed: function(error) {
			console.warn("Failed to load theme.json:", FileViewError.toString(error))
		}
		onLoaded: console.info("Successfuly loaded config theme file")

		ThemeAdapter {
			id: json
		}

	}

	FileView { // Helper to load read-only themes
		id: load_theme
		preload: false
		blockLoading: true
		onLoadFailed: function(error) {
			console.warn("Failed to load theme.json:", FileViewError.toString(error))
			path = ""
		}
		onLoaded: path = ""
		ThemeAdapter { id: load_json }
	}

	// Properties
	property var cs: json.theme.scheme === "light" ? cs_light : cs_dark
	property color accent: json.theme.accent
	property var background: ({
		image: json.theme.background.image,
		color: json.theme.background.color
	})

	// Color Schemes
	property var cs_light: ({
		background: "ivory",
		foreground: "#3f3f3f",
		inactive: "#6f6f6f",
		shadow: tint(accent, -0.8),
		success: "#8bd5a0",
		warning: "#f5a97f",
		critical: "#ed8796"
	})

	property var cs_dark: ({
		background: "#1a1b26",
		foreground: "ivory",
		inactive: "#444b6a",
		shadow: tint(accent, 0.4),
		success: "#8bd5a0",
		warning: "#f5a97f",
		critical: "#ed8796"
	})

	// IPC
	IpcHandler {
		target: "theme"

		function getColorScheme(): string { return json.theme.scheme }
		function setColorScheme(scheme: string) { json.theme.scheme = scheme }

		function getAccent(): color { return json.theme.accent }
		function setAccent(color: color) { json.theme.accent = color }

		function getBackgroundColor(): color { return json.theme.background.color }
		function setBackgroundColor(color: color) { json.theme.background.color = color }
		function getBackgroundImage(): string { return json.theme.background.image }
		function setBackgroundImage(path: string) { json.theme.background.image = FileSystem.expandThemePath(path) }
		function clearBackgroundImage() { json.theme.background.image = "" }

		function set(path: string) { 
			load_theme.path = FileSystem.expandThemePath(path + "/theme.json")
			json.copyTheme(load_json)
		}
	}

	// Utils
	function tint(color: color, amount: real) : color {
		if (amount > 0) {
			return Qt.rgba(
				color.r + (1.0 - color.r) * amount,
				color.g + (1.0 - color.g) * amount,
				color.b + (1.0 - color.b) * amount,
				1.0
			)
		} else {
			return Qt.rgba(
				color.r * (1.0 + amount),
				color.g * (1.0 + amount),
				color.b * (1.0 + amount),
				1.0
			)
		}
	}

}
