import QtQuick
import QtQuick.Layouts

Item {
	id: grid

	// Required properties, this is the number of rows
	// the model of the repeater and the delegate to
	// repeat.
	required property int rows
	required property var model
	required property Component delegate

	// Enumeration for step direction, positive means
	// that the step increases for each row, while 
	// negative decreases.
	readonly property bool stepPositive: true
	readonly property bool stepNegative: false

	// And the property which takes the value from the
	// previous enumeration.
	property bool stepDirection: stepPositive

	// Properties for controlling the spacings in the
	// layout. step is the size of the per row margin,
	// while the others mean the spacing in rows and
	// columns, being spacing a general one
	property int step: 30
	property int spacing: 10
	property int rowSpacing: spacing
	property int columnSpacing: spacing

	// Bind the Item size to the contents
	implicitWidth: layout.width
	implicitHeight: layout.height

	ColumnLayout {
		id: layout
		anchors.centerIn: parent
		spacing: columnSpacing

		Repeater {
			id: repeater
			model: grid.rows
			RowLayout {
				spacing: rowSpacing
				Layout.leftMargin: grid.step * ((stepDirection === stepPositive) ? index : grid.rows - 1 - index)
				Repeater {
					model: computeRowModel(grid.model, grid.rows, index)
					delegate: grid.delegate
				}
			}
		}
	}

	function computeRowModel(itemsModel, rows, rowIndex) {
		// If it's NOT an array → treat it as a number
		if (!Array.isArray(itemsModel)) {
			return Math.ceil(itemsModel / rows)
		}

		// Array case
		var perRow = Math.ceil(itemsModel.length / rows)
		var start = rowIndex * perRow
		var end = Math.min(start + perRow, itemsModel.length)

		return itemsModel.slice(start, end)
	}

}
