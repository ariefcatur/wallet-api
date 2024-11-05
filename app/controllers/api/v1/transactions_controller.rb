class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_request

  def create
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render json: transaction, status: :created
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    wallet = @current_user.wallet
    transactions = Transaction.where(source_wallet: wallet).or(Transaction.where(target_wallet: wallet))
    render json: transactions
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :source_wallet_id, :target_wallet_id)
  end
end