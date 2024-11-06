class Api::V1::WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :deposit, :withdraw, :transfer]

  def index
    @wallets = current_user.wallet
    render json: @wallets
  end

  def show
    render json: {
      id: @wallet.id,
      balance: @wallet.balance,
      owner_type: @wallet.owner_type,
      owner_id: @wallet.owner_id,
      transactions: @wallet.transactions.order(created_at: :desc).limit(10)
    }
  end

  def deposit
    perform_transaction(nil, @wallet, params[:amount])
  end

  def withdraw
    perform_transaction(@wallet, nil, params[:amount])
  end

  def transfer
    target_wallet = Wallet.find(params[:target_wallet_id])
    perform_transaction(@wallet, target_wallet, params[:amount])
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id])
    unless @wallet.owner == current_user
      render json: { error: 'Unauthorized access to this wallet' }, status: :unauthorized
    end
  end

  def perform_transaction(source_wallet, target_wallet, amount)
    amount_cents = (amount.to_f * 100).to_i

    transaction = Transaction.new(
      source_wallet: source_wallet,
      target_wallet: target_wallet,
      amount_cents: amount_cents
    )

    if transaction.save
      render json: {
        message: 'Transaction successful',
        transaction: {
          id: transaction.id,
          amount: transaction.amount_cents / 100.0,
          source_wallet_id: transaction.source_wallet_id,
          target_wallet_id: transaction.target_wallet_id,
          created_at: transaction.created_at
        }
      }, status: :ok
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end
end