class Api::V1::WalletsController < ApplicationController
  before_action :authenticate_request

  def show
    owner = params[:owner_type].classify.constantize.find(params[:owner_id])
    wallet = owner.wallet
    render json: { balance: wallet.balance }
  end
end