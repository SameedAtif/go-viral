class GigDeliverableReview < ApplicationRecord
  belongs_to :client
  belongs_to :gig_client
  belongs_to :gig_deliverable

  STATUS_TYPES_MAP = {
    ready_for_review: 'ready_for_review',
    approved: 'approved',
    rejected: 'rejected'
  }.freeze
  STATUS_TYPES = STATUS_TYPES_MAP.values

  validates :status, inclusion: { in: STATUS_TYPES }
  validates_length_of :remarks, minimum: 3
  validates_presence_of :remarks, :status, :rating

  after_save_commit :notify_creator, :schedule_influencer_payment, on: %i[create update], if: -> { saved_change_to_attribute?('status') }

  private

  def notify_creator
    return unless [STATUS_TYPES_MAP[:approved], STATUS_TYPES_MAP[:rejected]].include?(status)

    Notification.create!(
      resource_id: gig_client.gig.id,
      resource_type: gig_client.gig.class.name,
      user_id: gig_client.gig.influencer.user.id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: creator_notification_type,
      extra: creator_notification_extra
    )
  end

  def creator_notification_type
    if status == STATUS_TYPES_MAP[:approved]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_deliverable_approved]
    elsif status == STATUS_TYPES_MAP[:rejected]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_deliverable_rejected]
    end
  end

  def schedule_influencer_payment
    return if status != ::GigDeliverableReview::STATUS_TYPES_MAP[:approved]
    # TODO: Schedule payment
    CreditGigInfluencer.perform_at(15.days.from_now, id)
  end

  def creator_notification_extra
    if status == STATUS_TYPES_MAP[:approved]
      {
        title: 'Delivery approved',
        description: 'The client has approved the delivery',
        redirect_url: gig_client_path(gig_client.id),
        cta_button_text: 'Click here to view details'
      }
    elsif status == STATUS_TYPES_MAP[:rejected]
      {
        title: 'Delivery rejected',
        description: 'The client has rejected the delivery',
        redirect_url: gig_client_path(gig_client.id),
        cta_button_text: 'Click here to view details'
      }
    end
  end
end
