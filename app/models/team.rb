class Team < ApplicationRecord
  include Walletable

  has_many :user_teams
  has_many :users, through: :user_teams

  validates :name, presence: true, uniqueness: true
end