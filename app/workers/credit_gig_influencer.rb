class CreditGigInfluencer
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(deliverable_id)
    deliverable = GigDeliverableReview.find(deliverable_id)
    on_going_dispute = deliverable.gig_client.gig_disputes.where(status: ['pending_review', 'review_in_progress']).any?

    return if deliverable.status != ::GigDeliverableReview::STATUS_TYPES_MAP[:approved] || on_going_dispute

    InfluencerGigTransaction.create!(
      system_gig_transaction: deliverable.gig_client.system_gig_transaction,
      gig: deliverable.gig_client.gig,
      gig_client: deliverable.gig_client,
      influencer: deliverable.gig_client.gig.influencer,
      transaction_type: InfluencerGigTransaction::TRANSACTION_TYPES_MAP[:credit],
      gross_price: deliverable.gig_client.gig_package.price,
      fee: 0.00
    )
  end
end
