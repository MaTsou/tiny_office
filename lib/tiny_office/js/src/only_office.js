class EventsManager {
	constructor() { }
	/**************************************************
	 * Define here all OnlyOffice supported events
	 *************************************************/

	/********** onRequestClose() **********/
	onRequestClose() {
		docEditor.destroyEditor();
		window.close();
	};

	/********** onRequestSaveAs() **********/
	onRequestSaveAs() {
		console.log("on request save as called");
	};
	/**************************************************
	 * Below from events 'level' to events functions
	 *************************************************/
	getEvents(level) {
		switch (level) {
			case "full":
				return {
					onRequestClose: this.onRequestClose,
					onRequestSaveAs: this.onRequestSaveAs,
				}
			case "read-only":
				return {
					onRequestSaveAs: this.onRequestSaveAs
				}
			case "no-event":
				return {}
		}
	}
}
/**************************************************
 * docEditor building
 * oo_config is an html tag id containing config as text
 * oo_placeholder is a html tag (div) id which will contain
 * the only office 'iframe'
 **************************************************/
docEditor = new  DocEditorBuilder(
	new ConfigBuilder("oo_config"),
	new EventsManager()
).call("oo_placeholder");
