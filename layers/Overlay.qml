import QtQuick
import QtQuick.Controls

import Quickshell
import Quickshell.Wayland

import qs.services
import qs.modules.power_menu
import qs.modules.app_menu

Variants {
	model: Quickshell.screens
	delegate: Component {
		PanelWindow {
			id: overlay_window
			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

			// This window should not overlap with 
			// anything else.
			exclusionMode: ExclusionMode.Ignore

			required property var modelData
			screen: modelData

			// This window is transparent as we don't want to
			// cover the screen
			color: "transparent"

			// Clicks need to pass through the overlay panel 
			// so we set a mask
			mask: Region {}

			// Property to check if fullscreen and in the
			// active screen
			property bool isFullScreen: Niri.isFullScreen && (Niri.activeScreenName === screen.name)

			// Spawn accross the full screen both in width
			// and height.
			implicitHeight: screen.height
			implicitWidth: screen.width

			MouseArea {
				id: mouseCancelArea
				anchors.fill: parent
				onClicked: {
					MenuEvents.canceled()
				}
			}	



			PowerMenu { window: overlay_window }
			AppMenu { window: overlay_window }
		}
	}
}
