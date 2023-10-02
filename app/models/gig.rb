class Gig < ApplicationRecord
  belongs_to :influencer

  # One Gig can be bought by multiple clients
  has_many :gig_clients
  has_many :clients, through: :gig_clients
  # One Gig can have multiple platforms
  has_many :gig_platforms, dependent: :destroy
  has_many :platforms, through: :gig_platforms

  #One Gig can have multiple categories
  has_many :gig_packages
  has_many :gig_reviews
  has_many :gig_faqs

  STATUSES_MAP = {
    draft: 'draft',
    pending: 'pending',
    in_review: 'in_review',
    approved: 'approved',
    rejected: 'rejected',
    published: 'published',
  }.freeze
  STATUSES = STATUSES_MAP.values

  validates_presence_of :title, :status, :description
  validates_length_of :title, :description, minimum: 3
  validates :targeted_demographic_end_age, comparison: { greater_than: :targeted_demographic_start_age }
  validates :status, inclusion: { in: STATUSES }

  scope :approved, -> { where(status: Gig::STATUSES[:approved]) }
  scope :in_review, -> { where(status: Gig::STATUSES[:in_review]) }
  scope :pending, -> { where(status: Gig::STATUSES[:pending]) }
end
