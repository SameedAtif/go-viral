class Client < ApplicationRecord
  belongs_to :user

  has_many :projects
  # One Client can buy multiple gigs
  has_many :gig_clients
  has_many :gigs, through: :gig_clients
end
