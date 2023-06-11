class GigClient < ApplicationRecord
  belongs_to :gig
  belongs_to :client

  has_one :gig_category
end
