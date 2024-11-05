class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = generate_jwt_token(user.id)
      render json: { token: token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
