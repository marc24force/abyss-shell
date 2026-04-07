import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
	Layout.alignment: Qt.AlignCenter
	width: parent.direction === FlexboxLayout.Column ? parent.width : 2
	height: parent.direction === FlexboxLayout.Row ? parent.height : 2
	color: Theme.cs.foreground
	radius: 2
}
