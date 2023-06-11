class Platform < ApplicationRecord
  # One Platfom can have multiple gigs
  has_many :gig_platforms, dependent: :destroy
  has_many :gigs, through: :gig_platforms, dependent: :destroy
  # One Platfom can have multiple influencers
  has_many :influencer_platforms, dependent: :destroy
  has_many :influencers, through: :influencer_platforms, dependent: :destroy

  validates_presence_of :name, :url
end
