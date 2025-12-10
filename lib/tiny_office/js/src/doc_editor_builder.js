class DocEditorBuilder {
	constructor(configBuilder, eventsManager) {
		this.cfgBuilder = configBuilder;
		this.evtManager = eventsManager;
	}

	call(placeholder) {
		let doc = new DocsAPI.DocEditor(placeholder, this.#config());
		console.log(doc);
		return doc;
	}

	#config() {
		return this.cfgBuilder.call(this.evtManager);
	}
}

