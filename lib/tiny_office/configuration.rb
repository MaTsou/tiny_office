module TinyOffice
  class Configuration
    attr_accessor(
      :html_wrapper, :token_builder, :action_defaults, :logo,
      :onlyoffice_url, :onlyoffice_js_cdn
    )
  end
end
