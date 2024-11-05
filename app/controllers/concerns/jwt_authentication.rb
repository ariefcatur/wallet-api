module JwtAuthentication
  extend ActiveSupport::Concern

  def generate_jwt_token(user_id)
    JWT.encode(
      { user_id: user_id, exp: 24.hours.from_now.to_i },
      ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt_secret_key,
      'HS256'
    )
  end

  def decode_jwt_token(token)
    JWT.decode(
      token,
      ENV['JWT_SECRET_KEY'] || Rails.application.credentials.jwt_secret_key,
      true,
      algorithm: 'HS256'
    )[0]
  rescue JWT::DecodeError
    nil
  end
end