module TinyOffice
  class CloudEditor
    CLASS_PREFIX = 'TinyOffice'
    ACTION_TO_CLASS = {
      edit: 'Edit'
    }

    def initialize
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def call(action, &block)
      builder_class(action).
        new(configuration, &block).
        call
    end

    private

    def builder_class(action)
      Object.
        const_get(
          [
            CLASS_PREFIX,
            ACTION_TO_CLASS.fetch(action.to_sym, action.capitalize)
          ].join('::')
        )
    end
  end
end
