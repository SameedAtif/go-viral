class CreditGigClient
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(gig_client_id)
    gig_client = GigClient.find(gig_client_id)

    return unless [GigClient::STATUSES_MAP[:pending_review], GigClient::STATUSES_MAP[:accepted]].include?(gig_client.status)

    ClientGigTransaction.create!(
      system_gig_transaction: gig_client.system_gig_transaction,
      gig_client: gig_client,
      client: gig_client.client,
      transaction_type: ClientGigTransaction::TRANSACTION_TYPES_MAP[:credit],
      gross_price: gig_client.gig_package.price,
      fee: 0.00
    )
  end
end
