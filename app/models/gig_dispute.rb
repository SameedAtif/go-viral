class GigDispute < ApplicationRecord
  belongs_to :gig_client
  belongs_to :reviewer, optional: true

  has_many :system_gig_transactions

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

  after_create_commit :notify_reviewer
  after_update_commit :notify_parties, :issue_refund, if: -> { saved_change_to_attribute?('resolved_in_favor') || saved_change_to_attribute?('status') }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "created_by", "detail", "gig_client_id", "id", "resolved_at", "resolved_in_favor", "reviewer_id", "status", "updated_at"]
  end

  private

  def dispute_locked!
    return unless [STATUS_TYPES_MAP[:review_in_progress], STATUS_TYPES_MAP[:payment_approved]].include?(status)

    errors.add(:base, 'Cannot make changes to dispute once the review has started.')
  end

  def notify_reviewer
    Reviewer.all.pluck(:user_id).each do |user_id|
      Notification.create!(
        resource_id: gig_client.gig.id,
        resource_type: gig_client.gig.class.name,
        user_id: user_id,
        user_type: User::USER_ROLES[:reviewer],
        notification_type: Notification::NOTIFICATION_TYPES_MAP[:reviewer_dispute_opened],
        extra: {
          title: 'URGENT: New dispute to review',
          description: 'A new dispute has opened',
          redirect_url: admin_gig_dispute_path(gig_client.id),
          cta_button_text: 'Click here to view details'
        }
      )
    end
  end

  def notify_parties
    Notification.create!(
      resource_id: gig_client.gig.id,
      resource_type: gig_client.gig.class.name,
      user_id: gig_client.gig.influencer.user.id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[notification_type],
      extra: {
        title: 'Update on Dispute',
        description: 'You have a new update for the dispute',
      }
    )
    Notification.create!(
      resource_id: gig_client.gig.id,
      resource_type: gig_client.gig.class.name,
      user_id: gig_client.client.user.id,
      user_type: User::USER_ROLES[:client],
      notification_type: Notification::NOTIFICATION_TYPES_MAP[notification_type],
      extra: {
        title: 'Update on Dispute',
        description: 'You have a new update for the dispute',
      }
    )
  end

  def notification_type
    if saved_change_to_attribute?('status') && status == "review_in_progress"
      return :dispute_is_under_review
    end
    if saved_change_to_attribute?('resolved_in_favor')
      return :dispute_marked_as_resolved
    end
  end

  def issue_refund
    transaction = gig_client.system_gig_transaction
    # find the influencer gig application and system_gig_transaction
    return unless saved_change_to_attribute?('resolved_in_favor') && status == "payment_approved"
    # This means someone tried to issue a refund over a refund
    return unless transaction.transaction_type == 'debit'

    if resolved_in_favor == RESOURCE_TYPES_MAP[:client]
      ClientGigTransaction.create!(
        system_gig_transaction: transaction,
        gig_client: gig_client,
        client: client,
        transaction_type: ClientGigTransaction::TRANSACTION_TYPES_MAP[:credit],
        gross_price: gig_client.gig_package.price,
        fee: 0.00
      )
    elsif resolved_in_favor == RESOURCE_TYPES_MAP[:influencer]
      InfluencerGigTransaction.create!(
        system_gig_transaction: transaction,
        gig: gig,
        gig_client: gig_client,
        influencer: influencer,
        transaction_type: InfluencerGigTransaction::TRANSACTION_TYPES_MAP[:credit],
        gross_price: gig_client.gig_package.price,
        fee: 0.00
      )
    end
  end
end
