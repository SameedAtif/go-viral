class InfluencerProjectTransaction < ApplicationRecord
  belongs_to :system_project_transaction
  belongs_to :project
  belongs_to :project_application
  belongs_to :influencer

  TRANSACTION_TYPES_MAP = {
    credit: 'credit',
    debit: 'debit'
  }.freeze
  TRANSACTION_TYPES = TRANSACTION_TYPES_MAP.values

  validates_presence_of :gross_price, :fee, :transaction_type
  validates_numericality_of :fee, :gross_price, only_float: true, greater_than_or_equal_to: 0.00
  validates_inclusion_of :transaction_type, in: TRANSACTION_TYPES

  after_create_commit :notify_influencer

  def readonly?
    !new_record?
  end

  private

  def notify_influencer
    Notification.create!(
      resource_id: project.id,
      resource_type: project.class.name,
      user_id: influencer.user.id,
      user_type: User::USER_ROLES[:influencer],
      notification_type: influencer_notification_type
    )
  end

  def influencer_notification_type
    if transaction_type == TRANSACTION_TYPES_MAP[:credit]
      Notification::NOTIFICATION_TYPES_MAP[:creator_project_amount_credited]
    elsif transaction_type == TRANSACTION_TYPES_MAP[:debit]
      Notification::NOTIFICATION_TYPES_MAP[:creator_project_amount_debited]
    end
  end
end
