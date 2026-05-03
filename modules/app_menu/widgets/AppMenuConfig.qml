pragma Singleton
import QtQuick
import Quickshell

Item {
	property var leftKeys:  ['Q','W','E','R',
	                         'A','S','D','F',
	                         'Z','X','C','V',]

	property var rightKeys: ['I','O','P','[',
	                         'J','K','L','\'',
	                         'N','M',',','.']
	
	property var gridConfig: ({
		1: {rows: 1, cols: 1},
		2: {rows: 1, cols: 1},
		4: {rows: 2, cols: 1},
		8: {rows: 2, cols: 2},
		12: {rows: 2, cols: 3},
		16: {rows: 2, cols: 4},
		24: {rows: 3, cols: 4}
	})

	property var validSizes: Object.keys(gridConfig).map(function(k) { return parseInt(k); }).sort(function(a,b){ return b-a; })

	property int max_history: 10
}
