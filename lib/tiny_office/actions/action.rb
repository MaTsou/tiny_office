module TinyOffice
  class Action
    # A base class for all OnlyOffice actions.
    # All of them must specify either payload_is_config or payload_is_method : 
    # this is for token to be correctly composed
    #
    # Every child would possibly define default config content. This is the 
    # purpose of default class method. Depending of the content type (Hash or 
    # String), the initializing block can merge to or replace the defaults
    def self.payload_is_config
      define_method :payload_content, ->{ :config }
    end

    def self.payload_is_method
      define_method :payload_content, ->{ :method }
    end

    def self.default(name, content)
      @@config ||= ExtendedHash.new
      @@config.fine_merge(name => content)
    end

    def initialize(cloud_config)
      @cloud_config = cloud_config
      @token_builder = cloud_config.token_builder
      @config = editor_service_config(cloud_config).fine_merge(@@config)
      yield self
    end

    # Anticipating further development, I decide to return an object, even if 
    # for now only the config attribute is needed..
    def call
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
    attr_reader :token_builder, :config, :cloud_config

    def token
      token_builder.call(payload)
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

    def editor_service_config(configuration)
      ExtendedHash[configuration.editor_service_config || {}]
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
