class GigClient < ApplicationRecord
  belongs_to :gig
  belongs_to :client

  has_many :gig_packages
  STATUSES_MAP = {
    pending_review: 'pending_review',
    accepted: 'accepted',
    rejected: 'rejected',
    payment_verified: 'payment_verified',
    creator_credited: 'creator_credited',
    order_closed: 'order_closed'
  }
  STATUSES = STATUSES_MAP.values

  validates_inclusion_of :status, in: STATUSES
end
