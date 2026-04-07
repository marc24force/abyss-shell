import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.widgets
import qs.services

ShadowRectangle {
	id: root

	required property string icon
	required property string text
	required property string key

	required property bool hint
	required property string selection
	required property string pressed
	required property bool error


	implicitWidth: (layout.width > 100) ? layout.width : 100
	implicitHeight: (layout.height > 100) ? layout.height : 100

	property color text_color: root.selection === root.key ? Theme.cs.foreground : Theme.cs.inactive
	color: root.pressed === root.key ? Theme.cs.inactive : Theme.cs.background
	shadow_color: error ? Theme.cs.critical : Theme.cs.shadow

	ColumnLayout {
		id: layout
		anchors.centerIn: parent
		Text {
			text: root.icon
			font.pixelSize: Theme.getFontSize() * 3
			color: root.text_color
			Layout.alignment: Qt.AlignCenter
		}
		Text {
			text: root.text
			font.family: Theme.getFontSans()
			font.pixelSize: Theme.getFontSize() * 0.8
			color: root.text_color
			Layout.alignment: Qt.AlignCenter
		}
	}

	Text {
		text: root.key
		color: root.hint ? Theme.cs.foreground : Theme.cs.inactive
		font.family: Theme.getFontSans()
		font.bold: root.hint
		font.pixelSize: Theme.getFontSize() * 0.75
		x: (parent.width - width) * 0.90 
		y: 10
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		anchors.margins: width * 0.10
		onExited: MenuEvents.selected("")
		onEntered: MenuEvents.selected(key)
		onClicked: MenuEvents.confirmed(key)
	}	

}
