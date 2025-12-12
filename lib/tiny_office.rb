# frozen_string_literal: true

require 'jwt'
require_relative "tiny_office/version"
require_relative 'tiny_office/jwt_encoder'
require_relative 'tiny_office/cloud_editor'
require_relative 'tiny_office/configuration'
require_relative 'tiny_office/tiny_office'
require_relative 'tiny_office/services/events_level'
require_relative 'tiny_office/services/service_configuration'
require_relative 'tiny_office/services/editor_service'
require_relative 'tiny_office/services/edit'
require_relative 'tiny_office/wrapper/full_page'
require_relative 'tiny_office/js_type'

module TinyOffice
  class Error < StandardError; end
  # Your code goes here...
end
