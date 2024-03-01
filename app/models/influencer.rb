class Influencer < ApplicationRecord
  has_one_attached :avatar

  belongs_to :user

  has_many :gigs
  has_many :project_disputes
  has_many :project_applications
  has_many :project_deliverables
  # One Influencer can be in multiple projects
  has_many :project_influencers
  has_many :project, through: :project_influencers

  has_many :influencer_project_transactions
  has_many :influencer_gig_transactions

  # One Influencer can be on multiple platforms
  has_many :influencer_platforms, dependent: :destroy
  has_many :platforms, through: :influencer_platforms
  accepts_nested_attributes_for :influencer_platforms,
                                allow_destroy: true

  has_many :influencer_portfolios, dependent: :destroy
  accepts_nested_attributes_for :influencer_portfolios,
                                allow_destroy: true

  validates_length_of :bio, minimum: 3
  validates :avatar, size: { less_than: 10.megabytes , message: 'is too large' }, content_type: 'image/png'

  scope :all_except, ->(user) { where.not(id: user) }

  def self.ransackable_attributes(auth_object = nil)
    ["bio", "created_at", "id", "reviewed", "reviewer_id", "updated_at", "user_id"]
  end

  def gig_transactions
    SystemGigTransaction.joins(gig_package: [gig: :influencer])
                        .includes(:influencer_gig_transactions)
                        .includes(:client)
                        .includes(:gig_package)
                        .where(influencer: {id: id})
  end
end
