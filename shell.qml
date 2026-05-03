//@ pragma DataDir $BASE/abyss
//@ pragma StateDir $BASE/abyss
////@ pragma CacheDir $BASE/abyss

import Quickshell
import Quickshell.Io

import qs.layers
import qs.services

ShellRoot {
	id: root
	
	// Background panel, everything displayed
	// below normal windows. At the moment only
	// the background image / color
	Background {id: background}

	// Bottom panel, everything below normal
	// windows but on top of the background
	// This would be desktop icons or widgets
	// not implemented yet
	//Bottom {id: bottom}

	// Top panel, everything displayed on top
	// normal windows, but bellow fullscreen.
	// Bar, frame and application-like widgets.
	Top {id: top}

	// Overlay panel, everything displayed 
	// over all other windows, including 
	// fullscreen. Popup widgets and other
	// notifications
	Overlay {id: overlay}

	// How to access the overlay popups. This
	// is just a proof of concept. It may be
	// interesting to have a IpcHandler service
	// or popup mgr object
	
	IpcHandler {
		target: "popup"

		function power() { 
			var list = overlay.instances[Niri.activeScreenId].data
			var id
			for (var i = 0; i < list.length; i++) {
				if (list[i].name === "power") {
					id = i;
					break;
				}
			}
			list[id].toggle()
		}

		function apps() { 
			var list = overlay.instances[Niri.activeScreenId].data
			var id
			for (var i = 0; i < list.length; i++) {
				if (list[i].name === "apps") {
					id = i;
					break;
				}
			}
			list[id].toggle()
		}
	}
}
