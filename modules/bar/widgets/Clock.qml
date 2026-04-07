import QtQuick
import QtQuick.Layouts
import qs.services

Text {
	id: clock
	color: Theme.accent
	font { family: Theme.getFontMono(); pixelSize: Theme.getFontSize() * 1.5; bold: true }

	property string separator: {
		if(AbyssConfig.bar.anchor === "left" || AbyssConfig.bar.anchor === "right") {
			return "\n"
		} else return ":"
	}

	function updateTime() {
		const d = new Date()
		text = Qt.formatTime(d, "HH") + separator + Qt.formatTime(d, "mm")
	}


	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: updateTime()
	}

	Component.onCompleted: updateTime()

	lineHeight: 0.8  // adjust to reduce spacing
}

