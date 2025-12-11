module TinyOffice
  # I use a class rather than simply 'symbols' or 'string' to raise an error on 
  # wrong params..
  class JsType
    def self.cdn; :cdn; end
    def self.inline_script; :inline_script; end
  end
end
