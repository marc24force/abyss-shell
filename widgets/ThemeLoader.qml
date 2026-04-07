import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Item {
	id: root

	FileView {
		id: theme_file

		// File should be loaded from XDG_CONFIG_HOME, if not set we
		// default to ~/.config, no additional searches are made as we
		// already have a default theme.
		path: {
			var xdg = Quickshell.env("XDG_CONFIG_HOME")
			if (!xdg || xdg == "") xdg= Quickshell.env("HOME")+ "/.config"
			return xdg + "/abyss/theme.json"
		}

		// Monitor changes on the file
		watchChanges: true
		onFileChanged: this.reload()

		// We need to block loads to ensure that the data is fully read 
		// before proceeding. Same for writes as we want to avoid having
		// an inconsistent state due to a partial write.
		blockLoading: true
		blockWrites: true

		// Selfexplanatory, report when load and writes. Also warn if
		// the load has failed. No need to report the file, this is 
		// always the main config
		onAdapterUpdated: {
				writeAdapter()
				console.info("Updating config theme file")
		}

		onLoadFailed: function(error) {
			console.warn("Failed to load theme.json:", FileViewError.toString(error))
		}

		onLoaded: console.info("Successfuly loaded config theme file")

		// Set adapter to the property, as explained below this allows
		// to share it with the reader
		adapter: theme_adapter
	}

	//Property that defines a theme and related settings
	property JsonAdapter theme_adapter : JsonAdapter {
		property JsonObject theme : JsonObject {
			property string scheme: "dark"
			property color accent: "#7fffcc"
			property JsonObject background: JsonObject {
				property string image: "abyss/abyss-background.jpg"
				property color color: "black"
			}
		}
		property JsonObject font : JsonObject {
			property string mono: "Mono"
			property string sans: "Sans"
			property int size: 16
		}
	}


	//Functions
	
	// Getter & Setter for the color scheme
	function getColorScheme(): string { return theme_file.adapter.theme.scheme }
	function setColorScheme(scheme: string) { theme_file.adapter.theme.scheme = scheme }

	// Getter & Setter for the accent color
	function getAccent(): color { return theme_file.adapter.theme.accent }
	function setAccent(color: color) { theme_file.adapter.theme.accent = color }

	// Getter & Setter for the background color
	function getBackgroundColor(): color { return theme_file.adapter.theme.background.color }
	function setBackgroundColor(color: color) { theme_file.adapter.theme.background.color = color }

	// Getter & Setter for the background image. Outside of ThemeLoader
	// all paths should be absolute, we need to expand.
	function getBackgroundImage(): string { return FileSystem.expandThemePath(theme_file.adapter.theme.background.image) }
	function setBackgroundImage(path: string) { theme_file.adapter.theme.background.image = path }

	// Getter & Setter for the fonts, for the mono and sans family and
	// for the size
	function getFontSize(): int { return theme_file.adapter.font.size }
	function setFontSize(size: int) { theme_file.adapter.font.size = size }
	function getFontMono(): string { return theme_file.adapter.font.mono }
	function setFontMono(family: string) { theme_file.adapter.font.mono = family }
	function getFontSans(): string { return theme_file.adapter.font.sans }
	function setFontSans(family: string) { theme_file.adapter.font.sans = family }
		
	// Reader to open theme files without modifying them. Defined as a
	// component as this should only be used on limited ocasions.
	Component {
		id: reader_component
		FileView {
			adapter: theme_adapter
		}
	}

	// This is the more complex function as we require the theme reader
	// to open and read the new theme
	function setTheme(file: string) : void {
		// We create the reader and check it is valid
		if(!root.reader) {
			root.reader = reader_component.createObject(root)
			if (!root.reader) {
				console.error("Failed to create theme reader")
				return
			}
		}

		// Set the expanded path to the theme to read and wait for the load
		root.reader.path = FileSystem.expandThemePath(file + "/theme.json")
		root.reader.waitForJob()

		// reader and loader are bound to the same theme_adapter, updating one
		// updates the other. However needs to trigger adapterUpdated manually
		if (!root.reader.loaded) console.error("Failed to load theme", file)
		else root.reader.adapter.adapterUpdated()

		// Do not destroy, when user's change a theme they might do it again
		// several times. Instead we start a timer and destroy 1 minute after
		// the last update.
		destroy_timer.restart()
	}

	// Keep track of the reader so we can reuse or destroy it later
	property var reader: null

	// Timer to destroy the reader after 1 minute of not being used
	Timer {
		id: destroy_timer
		interval: 60000 // 1 minute = 60000 ms
		repeat: false
		onTriggered: {
			if (root.reader) {
				root.reader.destroy()
				root.reader = null
			}
		}
	}
}
