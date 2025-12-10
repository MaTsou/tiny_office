module TinyOffice
  class Configuration
    attr_accessor(
      :html_wrapper, :token_builder, :editor_service_config, :logo,
      :onlyoffice_url, :onlyoffice_js_cdn
    )

    def html_wrapper
      @html_wrapper ||= Wrapper::FullPage.new
    end

    def only_office_js_cdn
      @only_office_js_cdn ||= "https://github.com/MaTsou/tiny_office.git/lib/tiny_office/js/tinyoffice.min.js"
    end
  end
end
