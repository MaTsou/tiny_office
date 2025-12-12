module TinyOffice
  class EditorService
    # A base class for all OnlyOffice actions.
    # All of them must specify either payload_is_config or payload_is_method : 
    # this is for token to be correctly composed
    #
    # Every child would possibly define default config content.
    # configure method yields a ServiceConfiguration instance.
    # class level instance variables are use for this purpose. They allow 
    # distinct values for EditorService parent class and each of its 
    # subclasses..
    class << self
      def configuration
        @configuration ||= ServiceConfiguration.new
      end

      def configure
        yield configuration
      end

      # Here EditorService SUBCLASS class level methods used to customize 
      # configuration to the current service (editor_service subclasses are 
      # services)
      def payload_is_config
        define_method :payload_content, ->{ :config }
      end

      def payload_is_method
        define_method :payload_content, ->{ :method }
      end
    end

    # Instance level methods
    def initialize
      current_config = ServiceConfiguration.new
      yield current_config
      @config = EditorService.configuration.
        fine_merge(self.class.configuration).
        fine_merge(current_config)
    end

    # Anticipating further development, I decide to return an object, even if 
    # for now only the config attribute is needed..
    def call(cloud_config)
      @cloud_config = cloud_config
      TinyOffice.new(
        cloud_config: cloud_config,
        config: config.fine_merge(token: token).content.to_json,
        js_inner_script: js_inner_script
      )
    end

    private
    attr_reader :cloud_config, :config

    def token
      cloud_config.token_builder.call(payload)
    end

    def payload
      case payload_content
      when :config
        config.content
      when :method
        config.content[:method]
      else
        'no_payload'
      end
    end

    def symbolize_keys(hash)
      hash.transform_keys(&:to_sym)
    end

    def js_inner_script
      return '' unless js_inline?
      File.read(
        File.join(
          Gem.loaded_specs['tiny_office'].full_gem_path,
          'lib/tiny_office/js/tinyoffice.min.js'
        )
      )
    end

    def js_inline?
      cloud_config.tinyoffice_js_type.to_sym == JsType.inline_script
    end
  end
end
