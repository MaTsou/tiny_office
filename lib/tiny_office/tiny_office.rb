module TinyOffice
  # This is a response object to any action
  class TinyOffice
    attr_reader :config, :page_content, :js_inner_script

    def initialize(cloud_config:, config:, js_inner_script:)
      @config = config
      @page_content = cloud_config.html_wrapper.call(self, cloud_config)
      @js_inner_script = js_inner_script
    end
  end
end
