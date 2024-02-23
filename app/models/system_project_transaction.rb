class SystemProjectTransaction < ApplicationRecord
  belongs_to :project
  belongs_to :project_application
  belongs_to :client
  belongs_to :project_dispute, optional: true

  TRANSACTION_TYPES_MAP = {
    credit: 'credit', # credit = going in to the wallet
    debit: 'debit' # debit = out of the wallet (to bank or other user)
  }.freeze
  TRANSACTION_TYPES = TRANSACTION_TYPES_MAP.values

  validates_presence_of :gross_price, :fee, :transaction_token, :transaction_type
  validates_numericality_of :fee, :gross_price, only_float: true, greater_than_or_equal_to: 0.00
  validates_inclusion_of :transaction_type, in: TRANSACTION_TYPES

  after_create_commit :schedule_influencer_credit_transaction, :mark_payment_approved

  def readonly?
    !new_record?
  end

  private

  def schedule_influencer_credit_transaction
    # TODO: Move to job and schedule it after 'n' influencer days
    # if no dispute and payment approved
    # schedule based on influencer
    influencer = project_application.influencer
    on_going_dispute = influencer.project_disputes.where(project: project, resolved_at: nil).any?
    unapproved_deliverable_review = Influencer.joins(project_deliverables: :project_deliverable_reviews).where(
      project_deliverables: { influencer: influencer },
      project_deliverable_reviews: { project: project, status: [
          ProjectDeliverableReview::STATUS_TYPES_MAP[:ready_for_review], ProjectDeliverableReview::STATUS_TYPES_MAP[:rejected]
        ]
      }
    ).any?
    return if on_going_dispute && unapproved_deliverable_review && transaction_type == InfluencerProjectTransaction::TRANSACTION_TYPES_MAP[:credit]

    InfluencerProjectTransaction.find_or_create_by!(
      system_project_transaction: self,
      project: project,
      project_application: project_application,
      influencer: influencer,
      gross_price: gross_price,
      fee: fee,
      transaction_type: InfluencerProjectTransaction::TRANSACTION_TYPES_MAP[:credit]
    )
  end

  def mark_payment_approved
    return if transaction_type == "debit"

    project.update(payment_verified: true)
  end
end
