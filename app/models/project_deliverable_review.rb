class ProjectDeliverableReview < ApplicationRecord
  belongs_to :client
  belongs_to :project
  belongs_to :project_deliverable

  validate :remarks, minimum: 3
  validates :achieved_reach, :achieved_conversion, presence: true, numericality: { only_integer: true }
end
