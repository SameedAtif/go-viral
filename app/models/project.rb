class Project < ApplicationRecord
  belongs_to :client
  # One Project can have multiple influencers
  has_many :project_influencers, dependent: :destroy
  has_many :influencers, through: :project_influencers
  # One Project can have multiple platforms
  has_many :project_platforms, dependent: :destroy
  has_many :platforms, through: :project_platforms
  accepts_nested_attributes_for :project_platforms,
                                allow_destroy: true

  validates_presence_of :title, :description
  validates :budget, presence: true, numericality: { only_float: true }
  validates_length_of :title, :description, minimum: 3
end
