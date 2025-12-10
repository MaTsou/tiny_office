require 'jwt'

module TinyOffice
  class JwtEncoder
    attr_reader :secret, :header

    def initialize(secret:, header:)
      @secret = secret
      @header = header
    end

    def call(payload)
      JWT.encode(payload, secret, 'HS256', { typ: 'JWT', cty: header })
    end

    def decode(token)
      JWT.decode(token, secret, true, { algorithm: 'HS256' })
    end
  end
end
