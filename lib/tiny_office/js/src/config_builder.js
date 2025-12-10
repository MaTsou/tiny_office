class ConfigBuilder {
	constructor(id) { this.config = this.#raw_config(id) }

	call(eventManager) {
		this.#format_config(eventManager);
		return this.#cleared_config();
	}

	#raw_config(id) {
		return JSON.parse(document.getElementById(id).textContent);
	}

	#cleared_config() {
		delete(this.config.supported_events_level);
		return this.config;
	}

	#format_config(evtMng) {
		this.config.events = evtMng.getEvents(this.config.supported_events_level);
	}
}
