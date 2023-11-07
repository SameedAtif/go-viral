class Influencer < ApplicationRecord
  belongs_to :user

  has_many :gigs
  has_many :project_disputes
  has_many :project_applications
  has_many :project_deliverables
  # One Influencer can be on multiple platforms
  has_many :influencer_platforms, dependent: :destroy
  has_many :platforms, through: :influencer_platforms
  # One Influencer can be in multiple projects
  has_many :project_influencers
  has_many :project, through: :project_influencers

  has_many :influencer_project_transactions
  has_many :influencer_gig_transactions

  accepts_nested_attributes_for :influencer_platforms,
                                allow_destroy: true
                                # reject_if: proc { |att| att['platform_id'].blank?}

  has_many :influencer_portfolios, dependent: :destroy
  accepts_nested_attributes_for :influencer_portfolios,
                                allow_destroy: true

  scope :all_except, ->(user) { where.not(id: user) }
end
