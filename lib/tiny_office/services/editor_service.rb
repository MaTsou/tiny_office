module TinyOffice
  class EditorService
    # A base class for all OnlyOffice actions.
    # All of them must specify either payload_is_config or payload_is_method : 
    # this is for token to be correctly composed
    #
    # Every child would possibly define default config content. This is the 
    # purpose of default class method. Depending of the content type (Hash or 
    # String), the initializing block can merge to or replace the defaults
    #
    # Here EditorService class level methods
    def self.configuration=(configuration_hash)
      @@configuration = ExtendedHash[configuration_hash]
    end

    def self.configuration
      @@configuration ||= ExtendedHash.new
    end

    # Here EditorService SUBCLASS class level methods
    def self.payload_is_config
      define_method :payload_content, ->{ :config }
    end

    def self.payload_is_method
      define_method :payload_content, ->{ :method }
    end

    def self.default(name, to:)
      # tempted to replace ExtendedHash.new by configuration ?
      # No because 'default' is call when editor_service SUBCLASSES are 
      # required ! A this time, 'configuration' is not set..
      @@config ||= ExtendedHash.new
      @@config.fine_merge(name => to)
    end

    def initialize
      @config = self.class.configuration.fine_merge(@@config)
      yield self
      self
    end

    # Anticipating further development, I decide to return an object, even if 
    # for now only the config attribute is needed..
    def call(cloud_config)
      @cloud_config = cloud_config
      TinyOffice.new(
        cloud_config: cloud_config,
        config: config.merge(token: token).to_json,
        js_inner_script: js_inner_script
      )
    end

    # This is for any configuration attribute names
    def method_missing(name, *args)
      return super unless name[-1] == '='

      attr_name = name[..-2].to_sym
      config.fine_merge(attr_name => args.first)
    end

    private
    attr_reader :cloud_config, :config

    def token
      cloud_config.token_builder.call(payload)
    end

    def payload
      case payload_content
      when :config
        config
      when :method
        config[:method]
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
