import QtQuick
import QtQuick.Effects

import qs.services

Item {
	implicitWidth: 100
	implicitHeight: 100

	property color shadow_color: Theme.cs.shadow
	property int shadow_strength: AbyssConfig.frame.shadow_strength
	property color color: Theme.cs.background
	property int radius: AbyssConfig.frame.radius

	Rectangle {
		id: shadow_effect

		anchors.fill: parent

		antialiasing: true

		color: parent.shadow_color
		radius: parent.radius

		layer.enabled: true
		layer.effect: MultiEffect {
			blurEnabled: true
			blurMax: 8
			blur: 1
		}
	}

	Rectangle {
		id: body
		anchors.centerIn: parent
		implicitWidth: parent.implicitWidth - (parent.shadow_strength * 2)
		implicitHeight: parent.implicitHeight - (parent.shadow_strength * 2)
		radius: parent.radius - parent.shadow_strength

		color: parent.color
	}
}
