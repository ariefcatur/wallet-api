class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :valid_transaction_type
  validate :sufficient_funds

  before_create :process_transaction

  private

  def valid_transaction_type
    if source_wallet.nil? && target_wallet.nil?
      errors.add(:base, "Transaction must have at least one wallet")
    end
  end

  def sufficient_funds
    if source_wallet && source_wallet.balance < amount
      errors.add(:amount, "Insufficient funds in source wallet")
    end
  end

  def process_transaction
    ApplicationRecord.transaction do
      if source_wallet
        raise ActiveRecord::Rollback unless sufficient_funds
      end
      true
    end
  end
end