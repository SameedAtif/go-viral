class Gig < ApplicationRecord
  belongs_to :influencer

  # One Gig can be bought by multiple clients
  has_many :gig_clients
  has_many :clients, through: :gig_clients
  # One Gig can have multiple platforms
  has_many :gig_platforms, dependent: :destroy
  has_many :platforms, through: :gig_platforms

  #One Gig can have multiple categories
  has_many :gig_categories
  has_many :gig_reviews
  has_many :gig_faqs

  validates_presence_of :title
  validates_length_of :title, minimum: 3

  scope :approved, -> { where(status: Gig::STATUSES[:approved]) }
  scope :in_review, -> { where(status: Gig::STATUSES[:in_review]) }
  scope :pending, -> { where(status: Gig::STATUSES[:pending]) }

  STATUSES = {
    pending: 'pending',
    in_review: 'in_review',
    approved: 'approved'
  }.freeze
end
