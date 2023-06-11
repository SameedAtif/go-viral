class GigCategory < ApplicationRecord
  belongs_to :gig

  validates_presence_of :title, :description, :price
  validates_length_of :title, :description, minimum: 3
end
