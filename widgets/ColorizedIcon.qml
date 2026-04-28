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

	Loader {
		asynchronous: root.asynchronous
		sourceComponent: Item {

			Item {
				implicitWidth: root.width
				implicitHeight: root.height

				// First turn image into black and white using
				// saturation and brightness to increase the 
				// white component for darker icons.
				IconImage {  
					anchors.fill: parent
					source: root.source

					layer.enabled: true  
					layer.effect: MultiEffect {  
						saturation: -1.0
						brightness: 0.7
						contrast: 1.0
					}  
				}

				// Apply the colorization effect.
				layer.enabled: true  
				layer.effect: MultiEffect {  
					colorization: 1.0
					colorizationColor: root.tint
				}  
			}
		}
	}
}
