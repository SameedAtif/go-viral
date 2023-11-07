class InfluencerPortfolio < ApplicationRecord
  belongs_to :influencer
  validates_presence_of :title, :description
  validates_length_of :title, :description, minimum: 3
end
