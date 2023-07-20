class Client < ApplicationRecord
  belongs_to :user

  has_one :organization_detail, dependent: :destroy
  has_one :organization, through: :organization_detail

  has_many :projects
  has_many :project_deliverable_reviews
  # One Client can buy multiple gigs
  has_many :gig_clients, dependent: :destroy
  has_many :gigs, through: :gig_clients
end
