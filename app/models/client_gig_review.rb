class GigClient < ApplicationRecord
  belongs_to :gig
  belongs_to :client

  has_many :gig_packages

  validates_presence_of :title, :description, :rating
  validates :rating, numericality: { only_float: true }
end
