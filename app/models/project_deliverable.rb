class ProjectDeliverable < ApplicationRecord
  belongs_to :project_milestone
  belongs_to :influencer

  has_many :project_deliverable_reviews

  validates_presence_of :title, :description
  validates_length_of :title, :description, minimum: 3
end
