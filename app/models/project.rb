class Project < ApplicationRecord
  belongs_to :client
  # One Project can have multiple influencers
  has_many :project_influencers
  has_many :influencers, through: :project_influencers
  # One Project can have multiple platforms
  has_many :project_platforms
  has_many :platforms, through: :project_platforms

  validates_presence_of :title
  validates_length_of :title, minimum: 3
end
