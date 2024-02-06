class Notification < ApplicationRecord
  include EmailHandler

  belongs_to :source, polymorphic: true, optional: true
  belongs_to :user

  self.inheritance_column = :_type_disabled

  NOTIFICATION_TYPES_MAP = {
    new_project_request: 'new_project_request',
    creator_approved_for_project: 'creator_approved_for_project',
    creator_rejected_for_project: 'creator_rejected_for_project',
    client_creator_applied_to_project: 'client_creator_applied_to_project',
    client_project_approved: 'client_project_approved',
    client_project_rejected: 'client_project_rejected',
    client_project_expired: 'client_project_expired',
    creator_new_campaign_published: 'creator_new_campaign_published',
    creator_campaign_in_progress: 'creator_campaign_in_progress',
    creator_campaign_cancelled: 'creator_campaign_cancelled',
    reviewer_organization_created: 'reviewer_organization_created',
    client_organization_verified: 'client_organization_verified',
    client_creator_delivered_milestone: 'client_creator_delivered_milestone',
    creator_project_deliverable_approved: 'creator_project_deliverable_approved',
    creator_project_deliverable_rejected: 'creator_project_deliverable_rejected',
    client_package_downgrade_update: 'client_package_downgrade_update',
    client_package_downgrade_request: 'client_package_downgrade_request',
    creator_project_amount_credited: 'creator_project_amount_credited',
    creator_project_amount_debited: 'creator_project_amount_debited',
    reviewer_dispute_opened: 'reviewer_dispute_opened',
    dispute_is_under_review: 'dispute_is_under_review',
    dispute_marked_as_resolved: 'dispute_marked_as_resolved',
    creator_project_payment_is_approved: 'creator_project_payment_is_approved',
    reviewer_pending_gig_review: 'reviewer_pending_gig_review',
    creator_gig_approved: 'creator_gig_approved',
    creator_gig_rejected: 'creator_gig_rejected',
    creator_gig_in_review: 'creator_gig_in_review',
    client_gig_approved: 'client_gig_approved',
    client_gig_rejected: 'client_gig_rejected',
    creator_gig_deliverable_approved: 'creator_gig_deliverable_approved',
    creator_gig_deliverable_rejected: 'creator_gig_deliverable_rejected',
    client_creator_delivered_gig: 'client_creator_delivered_gig',
    creator_gig_amount_credited: 'creator_gig_amount_credited',
    creator_gig_amount_debited: 'creator_gig_amount_debited'
  }
  NOTIFICATION_TYPES = NOTIFICATION_TYPES_MAP.values

  validates :notification_type, inclusion: { in: NOTIFICATION_TYPES }
  validates :user_type, inclusion: { in: User::USER_ROLES_VALUES }
  validates :user_type, :notification_type, :resource_type, :resource_id, :user_id, presence: true
end

