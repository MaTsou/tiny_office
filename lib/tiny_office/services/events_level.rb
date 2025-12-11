module TinyOffice
  # I use a class rather than simply 'symbols' or 'string' to raise an error on 
  # wrong params..
  class EventsLevel
    def self.full; 'full'; end
    def self.read_only; 'read-only'; end
    def self.no_event; 'no-event'; end
  end
end
