class SystemGigTransactionsController < ApplicationController
  before_action :set_gig_package, only: :create

  def create
    # api call
    # create payment transaction data
    resource = SystemGigTransaction.new(gig_package: @gig_package)
    resource.client = current_user.client
    # TODO: Handle quantity
    resource.gross_price = resource.gig_package.price
    resource.fee = 0.00
    resource.transaction_token = "ABC"
    resource.transaction_type = "credit"
    authorize resource
    resource.save!
    # client would have a 1 day window (OR until influencer does not accept the gig_client)
    # failure to accept: automatically refund client, issue a warning to influencer
  end

  private

  def set_gig_package
    @gig_package = GigPackage.find(params[:gig_package_id])
  end
end
