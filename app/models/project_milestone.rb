class ProjectMilestone < ApplicationRecord
  belongs_to :project

  has_many :project_deliverables

  validates_presence_of :title, :description
  validates :budget, presence: true, numericality: { only_float: true }
  validates :conversion, :reach, presence: true, numericality: { only_integer: true }

  validates_length_of :title, :description, minimum: 3
end
