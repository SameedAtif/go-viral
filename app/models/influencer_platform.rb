class InfluencerPlatform < ApplicationRecord
  belongs_to :influencer
  belongs_to :platform

  validates_presence_of :followers, :reach, :url, :targeted_demographic_start_age,
                        :targeted_demographic_end_age
  validates :targeted_demographic_end_age, comparison: { greater_than: :targeted_demographic_start_age }

end
