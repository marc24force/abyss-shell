import Quickshell.Widgets  
import QtQuick
import QtQuick.Effects

// Icon tinted and can be loaded asynchronously. The item prereserves the
// space used by the icon to avoid any layout rearrangement when the icon
// is properly loaded.
Item {
	id: root
	required property string source
	property color tint: "red"
	property bool asynchronous: true
	property real light: 0

	Loader {
		asynchronous: root.asynchronous
		sourceComponent: Item {

			implicitWidth: root.width
			implicitHeight: root.height

			IconImage {  
				anchors.fill: parent
				source: root.source

				// Apply the colorization effect.
				layer.enabled: true  
				layer.effect: MultiEffect {  
					brightness: root.light
					contrast: -root.light
					colorization: 1.0
					colorizationColor: root.tint
				}  
			}

		}
	}
}
