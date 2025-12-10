module TinyOffice
  class Configuration
    attr_accessor(
      :html_wrapper, :token_builder, :action_defaults, :logo,
      :onlyoffice_url, :onlyoffice_js_cdn
    )

    def html_wrapper
      @html_wrapper ||= Wrapper::FullPage.new
    end
  end
end
