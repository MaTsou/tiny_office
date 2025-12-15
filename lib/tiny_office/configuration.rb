module TinyOffice
  DEFAULT_JS_CDN = "https://cdn.jsdelivr.net/gh/MaTsou/tiny_office@#{VERSION}/lib/tiny_office/js/tinyoffice.min.js"

  class Configuration
    attr_accessor :token_builder, :logo, :onlyoffice_url
    attr_writer :html_wrapper, :only_office_js_cdn, :tinyoffice_js_type

    def html_wrapper
      @html_wrapper ||= Wrapper::FullPage.new
    end

    def onlyoffice_js_cdn
      @onlyoffice_js_cdn ||= DEFAULT_JS_CDN
    end

    def tinyoffice_js_type
      @tinyoffice_js_type ||= JsType.inline_script
    end
  end
end
