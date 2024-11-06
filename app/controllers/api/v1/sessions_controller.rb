class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  def create
    user = User.find_by(email: params[:email] || params[:session][:email])

    Rails.logger.debug "Login attempt for email: #{params[:email] || params[:session][:email]}"
    Rails.logger.debug "User found: #{user.present?}"

    if user&.authenticate(params[:password] || params[:session][:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      Rails.logger.debug "Authentication failed for user: #{user&.id}"
      render json: {
        error: 'Invalid email or password'
      }, status: :unauthorized
    end
  rescue => e
    Rails.logger.error "Login error: #{e.message}"
    render json: {
      error: 'An error occurred during login'
    }, status: :internal_server_error
  end
end
