module TinyOffice
  # This is a response object to any action
  class TinyOffice
    attr_reader :config, :page_content

    def initialize(cloud_config:, config:)
      @config = config
      @page_content = cloud_config.html_wrapper.call(self, cloud_config)
    end
  end
end
