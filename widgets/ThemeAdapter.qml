import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

JsonAdapter {
	property JsonObject theme : JsonObject {
		property string scheme: "dark"
		property color accent: "#7fffcc"
		property JsonObject background: JsonObject {
			property string image: Quickshell.shellDir + "/assets/themes/abyss/abyss-background.jpg"
			property color color: "black"
		}
	}

	property bool blockAdapterUpdates: false

	function copyTheme(src: JsonAdapter) : void {
		blockAdapterUpdates = true
		theme.scheme = src.theme.scheme
		theme.accent = src.theme.accent
		theme.background.image = FileSystem.expandThemePath(src.theme.background.image)
		theme.background.color = src.theme.background.color
		blockAdapterUpdates = false
	}
}
