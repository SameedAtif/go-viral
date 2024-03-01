class Client < ApplicationRecord
  belongs_to :user

  has_one :organization_detail, dependent: :destroy
  has_one :organization, through: :organization_detail

  has_many :project_deliverable_reviews
  # One Client can buy multiple gigs
  has_many :gig_clients, dependent: :destroy
  has_many :gigs, through: :gig_clients
  has_many :organization_system_package_transactions
  has_many :system_project_transactions
  has_many :client_project_transactions
  has_many :project_disputes
  has_many :client_gig_reviews
  has_many :system_gig_transactions
  has_many :client_gig_transactions
  has_many :gig_deliverable_reviews

  def gig_transactions
    SystemGigTransaction.joins(gig_clients: :client)
                        .includes(:influencer_gig_transactions)
                        .includes(:client_gig_transactions)
                        .includes(:gig_package)
                        .where(client: {id: id})
  end
end
