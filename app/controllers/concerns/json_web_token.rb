require 'jwt'

module JsonWebToken
    extend ActiveSupport::Concern
    JWT_SECRET_KEY = ENV["JWT_SECRET"] || "placeholder_secret"

    def encode_token(payload, exp = 12.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, JWT_SECRET_KEY)
    end

    def decode_token(token)
        print JWT_SECRET_KEY
        decoded = JWT.decode(token, JWT_SECRET_KEY)[0]
        HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError, JWT::ExpiredSignature
        nil
    end
end