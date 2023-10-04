class GigDispute < ApplicationRecord
  belongs_to :gig
  belongs_to :client
  belongs_to :gig_package
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

  after_create_commit :notify_reviewer
  after_update_commit :notify_parties, :issue_refund, if: -> { saved_change_to_attribute?('resolved_in_favor') || saved_change_to_attribute?('status') }

  private

  def dispute_locked!
    return unless [STATUS_TYPES_MAP[:review_in_progress], STATUS_TYPES_MAP[:payment_approved]].include?(status)

    errors.add(:base, 'Cannot make changes to dispute once the review has started.')
  end

  def notify_reviewer
    Reviewer.all.pluck(:user_id).each do |user_id|
      Notification.create!(
        resource_id: gig.id,
        resource_type: gig.class.name,
        user_id: user_id,
        user_type: User::USER_ROLES[:reviewer],
        notification_type: Notification::NOTIFICATION_TYPES_MAP[:reviewer_dispute_opened]
      )
    end
  end

  def notify_parties
    [influencer, client].each do |role|
      Notification.create!(
        resource_id: gig.id,
        resource_type: gig.class.name,
        user_id: role.user.id,
        user_type: User::USER_ROLES[user_type(role)],
        notification_type: Notification::NOTIFICATION_TYPES_MAP[notification_type]
      )
    end
  end

  def user_type(role)
    role.class == Influencer ? :influencer : :client
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
    return unless saved_change_to_attribute?('resolved_in_favor') && status == "payment_approved"
    # find the influencer gig application and system_gig_transaction

    gig_client = GigClient.find_by(gig_package: gig_package, gig: gig, influencer: influencer)
    transaction = SystemGigTransaction.find_by(client: client, gig_package: gig_package)
    if resolved_in_favor == RESOURCE_TYPES_MAP[:client]
      ClientGigTransaction.create!(
        system_gig_transaction: transaction,
        gig_client: gig_client,
        client: client,
        transaction_type: ClientGigTransaction::TRANSACTION_TYPES_MAP[:credit],
        gross_price: gig_client.budget,
        fee: 0.00
      )
    elsif resolved_in_favor == RESOURCE_TYPES_MAP[:influencer]
      InfluencerGigTransaction.create!(
        system_gig_transaction: transaction,
        gig: gig,
        gig_client: gig_client,
        influencer: influencer,
        transaction_type: InfluencerGigTransaction::TRANSACTION_TYPES_MAP[:credit],
        gross_price: gig_client.budget,
        fee: 0.00
      )
    end
  end
end
