class GigPackage < ApplicationRecord
  belongs_to :gig

  has_many :client_gig_reviews
  has_many :system_gig_transactions

  validates_presence_of :title, :description, :price
  validates_length_of :title, :description, minimum: 3
  validates :price, numericality: { only_float: true }
  validates :delivery_estimation, :review_limit, numericality: { greater_than_or_equal_to: 1 }

  has_rich_text :description
end
