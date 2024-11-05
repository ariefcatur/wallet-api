class User < ApplicationRecord
  include Walletable

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end