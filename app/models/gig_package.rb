class GigPackage < ApplicationRecord
  belongs_to :gig

  validates_presence_of :title, :description, :price
  validates_length_of :title, :description, minimum: 3
  validates :price, numericality: { only_float: true }
  validates :delivery_estimation, :review_limit, numericality: { greater_than_or_equal_to: 1 }
end
