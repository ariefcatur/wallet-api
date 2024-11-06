class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validate :validate_wallets
  validate :validate_sufficient_funds

  after_create :update_wallet_balances

  private

  def validate_wallets
    if source_wallet.nil? && target_wallet.nil?
      errors.add(:base, "Either source or target wallet must be present")
    end

    if source_wallet.present? && target_wallet.present?
      if source_wallet == target_wallet
        errors.add(:base, "Source and target wallets cannot be the same")
      end
    end
  end

  def validate_sufficient_funds
    if source_wallet.present? && source_wallet.balance_cents < amount_cents
      errors.add(:base, "Insufficient funds in source wallet")
    end
  end

  def update_wallet_balances
    ApplicationRecord.transaction do
      source_wallet&.update_balance!
      target_wallet&.update_balance!
    end
  end
end