pragma Singleton  
import Quickshell  
import Quickshell.Io  

Singleton {  
	id: root  

	// FileView with JsonAdapter for automatic persistence  
	FileView {  
		id: historyFile  
		path: Quickshell.statePath("app-history.json")  
		atomicWrites: true  

		onAdapterUpdated: writeAdapter()

		adapter: JsonAdapter {  
			id: jsonAdapter  
			property var history: []  
		}  
	}  

	function add(appName) {  
		if (!appName || appName.length === 0) return  

		var tmp = jsonAdapter.history.slice()

		var index = tmp.indexOf(appName)  
		if (index !== -1) {  
			tmp.splice(index, 1)  
		}  

		tmp.unshift(appName)  

		while (tmp.length > AppMenuConfig.max_history) {  
			tmp.pop()  
		}  

		jsonAdapter.history = tmp.slice()  
	}  

	function get() {  
		return jsonAdapter.history.slice()  
	}  
}
