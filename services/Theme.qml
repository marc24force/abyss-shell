pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.widgets
import qs.services

Item {
	id: root

	// Instance of the theme loader, this is monitoring the current
	// theme and monitoring file changes. Altough it shouldn't be
	// used a lot (only when changing themes) can't be dynamic if 
	// we want to support hot-reload for themes.
	ThemeLoader { id: loader }

	// Properties for easy access to the theme values from other
	// modules.
	readonly property var cs: loader.getColorScheme() === "light" ? cs_light : cs_dark
	readonly property color accent: loader.getAccent()
	readonly property var background: ({
		image: loader.getBackgroundImage(),
		color: loader.getBackgroundColor()
	})

	// Properties for easy access to the font values from other
	// modules.
	readonly property font font: ({
		family: loader.getFont().split(":")[0].trim(),
		pixelSize: parseInt(loader.getFont().split(":")[1])
	})

	// Color Schemes
	readonly property var cs_light: ({
		background: "ivory",
		foreground: "#3f3f3f",
		inactive: "#6f6f6f",
		shadow: tint(accent, -0.8),
		success: "#8bd5a0",
		warning: "#f5a97f",
		critical: "#ed8796"
	})

	readonly property var cs_dark: ({
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

		function getColorScheme(): string { return loader.getColorScheme() }
		function setColorScheme(scheme: string) { loader.setColorScheme(scheme) }

		function getAccent(): color { return loader.getAccent() }
		function setAccent(color: color) { loader.setAccent(color) }

		function getBackgroundColor(): color { return loader.getBackgroundColor() }
		function setBackgroundColor(color: color) { loader.setBackgroundColor(color) }
		function getBackgroundImage(): string { return loader.getBackgroundImage() }
		function setBackgroundImage(path: string) { loader.setBackgroundImage(path) }
		function clearBackgroundImage() { loader.setBackgroundImage("") }

		function getFont(): string { return loader.getFont() }
		function setFont(font: string, size: int) { loader.setFont(font, size) }

		function set(path: string) { loader.setTheme(path) }
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
