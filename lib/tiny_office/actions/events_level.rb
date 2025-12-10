module TinyOffice
  class EventsLevel
    def self.full; 'full'; end
    def self.read_only; 'read-only'; end
    def self.no_event; 'no-event'; end

    def self.method_missing(name); 'no-event'; end
  end
end
