import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import qs.modules
import qs.services
import qs.modules.bar

ShellRoot {
	id: root
	Background {id: background}
	Bar {id: bar}
	MainFrame {id: frame}

//	PopupWindow {
//		anchor.window: frame.instances[Niri.activeScreenId]
//		anchor.rect.x: anchor.window.width / 2 - width / 2
//		anchor.rect.y: anchor.window.height / 2 - height / 2
//
//		Button {
//			anchors.centerIn: parent
//			text: "show popup"
//
//			// accessing popupLoader.item will force the loader to
//			// finish loading on the UI thread if it isn't finished yet.
//			onClicked: popupLoader.item.visible = !popupLoader.item.visible
//		}
//
//		implicitWidth: 200
//		implicitHeight: 200
//
//		visible: false
//	}
}
