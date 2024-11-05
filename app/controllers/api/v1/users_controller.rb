class Api::V1::UsersController < ApplicationController
  # Skip authentication for user creation
  skip_before_action :authenticate_request, only: [:create]

  def create
    user = User.new(user_params)

    if user.save
      # Generate JWT token for immediate login after signup
      token = generate_jwt_token(user.id)
      render json: {
        message: "User created successfully",
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end