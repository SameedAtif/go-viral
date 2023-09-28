class ProjectDispute < ApplicationRecord
  belongs_to :project
  belongs_to :client
  belongs_to :influencer
  belongs_to :reviewer, optional: true

  STATUS_TYPES_MAP = {
    pending_review: 'pending_review',
    review_in_progress: 'review_in_progress',
    payment_approved: 'payment_approved'
  }.freeze
  STATUS_TYPES = STATUS_TYPES_MAP.values
  RESOURCE_TYPES_MAP = {
    influencer: 'influencer',
    client: 'client'
  }
  RESOURCE_TYPES = RESOURCE_TYPES_MAP.values

  validates_presence_of :created_by, :status, :detail
  validates_inclusion_of :status, in: STATUS_TYPES
  validates_inclusion_of :created_by, :resolved_in_favor, in: RESOURCE_TYPES, allow_blank: true
  validate :dispute_locked!, if: -> { saved_change_to_attribute?('detail') }

  private

  def dispute_locked!
    return unless [STATUS_TYPES_MAP[:review_in_progress], STATUS_TYPES_MAP[:payment_approved]].include?(status)

    errors.add(:base, 'Cannot make changes to dispute once the review has started.')
  end
end
