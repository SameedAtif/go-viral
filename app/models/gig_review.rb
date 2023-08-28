class GigReview < ApplicationRecord
  belongs_to :gig
  belongs_to :reviewer

  validates_presence_of :feedback
end
