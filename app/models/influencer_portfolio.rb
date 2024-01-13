class InfluencerPortfolio < ApplicationRecord
  belongs_to :influencer

  validates_presence_of :title, :description, :start_time, :end_time, :content_link
  validates_length_of :title, :description, minimum: 3
  validates :end_time, comparison: { greater_than: :start_time }
end
