class ProjectDeliverableReview < ApplicationRecord
  belongs_to :client
  belongs_to :project
  belongs_to :project_deliverable

  STATUS_TYPES_MAP = {
    ready_for_review: 'ready_for_review',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze
  STATUS_TYPES = STATUS_TYPES_MAP.values

  validates :status, inclusion: { in: STATUS_TYPES }
  validates_length_of :remarks, minimum: 3
  validates :achieved_reach, :achieved_conversion, numericality: { only_integer: true }
end
