import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland

import qs.widgets
import qs.services

Variants {
	model: Quickshell.screens
	delegate: Component {
		PanelWindow {
			id: background_window
			WlrLayershell.layer: WlrLayer.Background

			required property var modelData
			screen: modelData

			// This is the background image, if the image
			// is null then it's not shown. TODO: support
			// animated or list of images.
			Image {
				id: image
				anchors.fill: parent
				fillMode: Image.PreserveAspectCrop

				source: Theme.background.image
				visible: Theme.background.image != ""
			}

			// Background color painted below the image
			// not really used unless the image is set null
			color: Theme.background.color

			// This window should not overlap with 
			// anything else.
			exclusionMode: ExclusionMode.Ignore

			// Spawn accross the full screen both in width
			// and height.
			implicitHeight: screen.height
			implicitWidth: screen.width
		}
	}
}
