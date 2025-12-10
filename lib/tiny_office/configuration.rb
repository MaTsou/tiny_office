module TinyOffice
  DEFAULT_JS_CDN = "https://cdn.jsdelivr.net/gh/MaTsou/tiny_office@#{VERSION}/lib/tiny_office/js/tinyoffice.min.js"

  class Configuration
    attr_accessor(
      :html_wrapper, :token_builder, :editor_service_config, :logo,
      :onlyoffice_url, :onlyoffice_js_cdn
    )

    def html_wrapper
      @html_wrapper ||= Wrapper::FullPage.new
    end

    def onlyoffice_js_cdn
      @onlyoffice_js_cdn ||= DEFAULT_JS_CDN
    end
  end
end
