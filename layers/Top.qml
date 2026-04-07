import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.widgets
import qs.modules.bar
import qs.services

Variants {
	model: Quickshell.screens
	delegate: Component {
		PanelWindow {
			id: top_window
			WlrLayershell.layer: WlrLayer.Top

			required property var modelData
			screen: modelData

			// Top is already below fullscreen, however this
			// hides before the fullscreen animation completes
			visible: !Niri.isFullScreen || (Niri.activeScreenName != screen.name)

			// The panel itself it's invisible, only items
			// are shown, this is required for the frame
			color: "transparent"

			// We want the frame to be click-through so we
			// need a mask over it with XOR
			mask: Region {
				item: frame
				intersection: Intersection.Xor
			}

			// Spawn accross the full screen both in width
			// and height.
			implicitHeight: screen.height
			implicitWidth: screen.width

			// Bar configuration variable, really an alias for
			// easier access.
			readonly property var barConfig: AbyssConfig.bar

			// Frame configuratino variable, really an alias 
			// for easier access
			readonly property var frameConfig: AbyssConfig.frame

			// Anchored to the bar.anchor so the exclusiveZone
			// is removed from there.
			anchors.left: barConfig.anchor === "left"
			anchors.right: barConfig.anchor === "right"
			anchors.top: barConfig.anchor === "top"
			anchors.bottom: barConfig.anchor === "bottom"
			
			// We reserve an exclusive zone for the bar which
			// corresponds to the bar width.
			exclusiveZone: barConfig.size

			FlexboxLayout {
				anchors.fill: parent
				
				// Direction depends on the bar.anchor, use reversed if 
				// right or bottom to properly set the layout
				direction: {
					if (barConfig.anchor === "right") return FlexboxLayout.RowReverse
					if (barConfig.anchor === "left") return FlexboxLayout.Row
					if (barConfig.anchor === "top") return FlexboxLayout.Column
					if (barConfig.anchor === "bottom") return FlexboxLayout.ColumnReverse
				}

				Bar { 
					id: bar
					size: barConfig.size
					anchor: barConfig.anchor
				}

				Frame{
					id: frame
					Layout.fillHeight: true
					Layout.fillWidth: true

					radius: frameConfig.radius
					color: Theme.cs.background
					shadow_color: Theme.cs.shadow
					shadow_strength: frameConfig.shadow_strength
					size: frameConfig.size
				}
			}
		}
	}
}

