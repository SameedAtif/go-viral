class ProjectApplication < ApplicationRecord
  belongs_to :project
  belongs_to :influencer

  validates_presence_of :title, :description, :status
  validates_length_of :title, :description, minimum: 3
end
