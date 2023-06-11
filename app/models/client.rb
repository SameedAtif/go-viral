class Client < ApplicationRecord
  belongs_to :user

  has_many :projects, dependent: :destroy
  # One Client can buy multiple gigs
  has_many :gig_clients, dependent: :destroy
  has_many :gigs, through: :gig_clients, dependent: :destroy
end
