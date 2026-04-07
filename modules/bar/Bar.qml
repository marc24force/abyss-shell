import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.services
import "widgets"

Rectangle {
	id: bar

	required property var anchor
	required property int size

	property var screenRatio: top_window.screen.width / top_window.screen.height

	color: Theme.cs.background

	// Width and height depend on the direction
	// either the screen size or the property 
	implicitHeight: (anchor === "left" || anchor === "right") ? parent.height : size
	implicitWidth: (anchor === "left" || anchor === "right") ? size : parent.width

	FlexboxLayout {

		anchors.fill: parent

		// Assign direction depending on anchor
		direction: {
			if (bar.anchor === "right") return FlexboxLayout.Column
			if (bar.anchor === "left") return FlexboxLayout.Column
			if (bar.anchor === "top") return FlexboxLayout.Row
			if (bar.anchor === "bottom") return FlexboxLayout.Row
		}

		// Items are centered in
		alignItems: FlexboxLayout.AlignCenter

		// Default item separation, is the opposite as
		// the direction, we want larger spaces in row
		// mode, so column gap is larger
		rowGap: 8
		columnGap: rowGap * screenRatio

		// Bar margins configuration variable, really an alias for
		// easier access.
		readonly property var margins: AbyssConfig.bar.margins

		// Adjust margins depending on direction. Also need to adjust
		// the margin to account for the frame size so visually it's
		// the same on both sides and elements are centered
		anchors.topMargin: {
			if (direction === FlexboxLayout.Column) return margins.long
			if (parent.anchor === "top") return margins.short + AbyssConfig.frame.size
			return margins.short
		}
		anchors.bottomMargin: {
			if (direction === FlexboxLayout.Column) return margins.long
			if (parent.anchor === "top") return margins.short
			return margins.short + AbyssConfig.frame.size
		}
		anchors.leftMargin: {
			if (direction === FlexboxLayout.Row) return margins.long
			if (parent.anchor === "left") return margins.short + AbyssConfig.frame.size
			return margins.short
		}
		anchors.rightMargin: {
			if (direction === FlexboxLayout.Row) return margins.long
			if (parent.anchor === "left") return margins.short
			return margins.short + AbyssConfig.frame.size
		}


		/* List of bar widgets */
		Logo {}
		Splitter {}
		//Workspaces {}
		Spacer {}
		//Splitter {}
		//Tray {}
		Spacer {}
		Splitter {}
		//Monitor{} //CPU, GPU, RAM, Disk
		//Volume{} //source, volume, input, volume
		//Display{} // brillantor
		Network{} //TODO eth, vpn
		Battery{}
		Splitter {}
		Clock {}
	}
}
