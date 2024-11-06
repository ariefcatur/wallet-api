class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV['JWT_SECRET_KEY']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    raise "Token has expired"
  rescue JWT::DecodeError
    raise "Invalid token"
  end
end