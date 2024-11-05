class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :source_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :target_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  def balance
    credit_sum = target_transactions.sum(:amount)
    debit_sum = source_transactions.sum(:amount)
    credit_sum - debit_sum
  end
end