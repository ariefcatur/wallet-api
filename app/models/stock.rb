class Stock < ApplicationRecord
  include Walletable

  validates :symbol, presence: true, uniqueness: true
  validates :name, presence: true
end