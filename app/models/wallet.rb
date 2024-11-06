class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :credit_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'
  has_many :debit_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'

  validates :balance_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def balance
    balance_cents / 100.0
  end

  def update_balance!
    credits = credit_transactions.sum(:amount_cents)
    debits = debit_transactions.sum(:amount_cents)
    update!(balance_cents: credits - debits)
  end
end