class ApplicationController < ActionController::API
  include JwtAuthentication

  # Skip authentication by default and add it to specific controllers
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = decode_jwt_token(header)
      @current_user = User.find(decoded['user_id'])
    rescue StandardError => e
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
