class GigClient < ApplicationRecord
  belongs_to :gig
  belongs_to :client
  belongs_to :gig_package
  belongs_to :system_gig_transaction

  # if it's not accepted, it would automatically be rejected in 1 day and the full payment would be refunded to the client.
  STATUSES_MAP = {
    pending_review: 'pending_review',
    accepted: 'accepted',
    rejected: 'rejected',
    request_rolled_back: 'request_rolled_back',
    creator_credited: 'creator_credited',
    order_closed: 'order_closed'
  }
  STATUSES = STATUSES_MAP.values

  validates_inclusion_of :status, in: STATUSES

  after_create_commit :schedule_client_refund_transaction
  after_save_commit :notify_client, :notify_creator, if: -> { saved_change_to_attribute?('status') }

  private

  def notify_client
    return unless [STATUSES_MAP[:approved], STATUSES_MAP[:rejected]].include?(status)

    Notification.create!(
      resource_id: gig.id,
      resource_type: gig.class.name,
      user_id: client.user_id,
      user_type: User::USER_ROLES[:client],
      notification_type: client_notification_type
    )
  end

  def notify_creator
    return unless [STATUSES_MAP[:creator_credited], STATUSES_MAP[:pending_review]].include?(status)

    Notification.create!(
      resource_id: gig.id,
      resource_type: gig.class.name,
      user_id: influencer.user_id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: creator_notification_type
    )
  end

  def client_notification_type
    if status == STATUSES_MAP[:approved]
      Notification::NOTIFICATION_TYPES_MAP[:client_gig_approved]
    elsif status == STATUSES_MAP[:rejected]
      Notification::NOTIFICATION_TYPES_MAP[:client_gig_rejected]
    end
  end

  def creator_notification_type
    if status == STATUSES_MAP[:pending_review]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_pending_review]
    elsif status == STATUSES_MAP[:creator_credited]
      Notification::NOTIFICATION_TYPES_MAP[:creator_gig_creator_credited]
    end
  end


  def schedule_client_refund_transaction
    # TODO: Move to background job
    return unless [GigClient::STATUSES_MAP[:pending_review], GigClient::STATUSES_MAP[:accepted]].include?(status)


    ClientGigTransaction.create!(
      system_gig_transaction: system_gig_transaction,
      gig_client: self,
      client: client,
      transaction_type: ClientGigTransaction::TRANSACTION_TYPES_MAP[:credit],
      gross_price: gig_package.price,
      fee: 0.00
    )
  end
end
