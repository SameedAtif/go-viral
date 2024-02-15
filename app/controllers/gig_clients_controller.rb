class GigClientsController < ApplicationController
  before_action :set_gig_client, :validate_status, only: [:show, :update]
  before_action :seller_navbar, only: %i[show manage_orders]

  layout "pages_with_search_bar"

  def show
    @gig = @gig_client.gig
    @client = @gig_client.client
    @gig_package = @gig_client.gig_package
    @transaction_detail = @gig_client.system_gig_transaction
    @gig_deliverable =  if verified_role.is_a?(Client)
                          @gig_client.gig_deliverables.find_by(active: true)
                        elsif verified_role.is_a?(Influencer)
                          GigDeliverable.new
                        end
    # TODO: Fetch by status, at a time only one can be active.
    @gig_dispute = @gig_client.gig_disputes.first || GigDispute.new
  end

  def manage_orders
    @gig_clients = scoped_orders
  end

  def update
    @gig_client.assign_attributes(permitted_params)
    authorize @gig_client
    @gig_client.save!
    redirect_to gig_client_path(@gig_client), notice: "Order updated"
  end

  private

  def set_gig_client
    @gig_client = GigClient.find(params[:id])
  end

  def permitted_params
    params.require(:gig_client).permit(
      :status
    )
  end

  def valid_client_status?
    status = params.dig(:gig_client, :status)
    return true if status.blank?

    [::GigClient::STATUSES_MAP[:request_rolled_back]].include?(status)
  end

  def valid_influencer_status?
    status = params.dig(:gig_client, :status)
    return true if status.blank?

    [::GigClient::STATUSES_MAP[:accepted], ::GigClient::STATUSES_MAP[:rejected]].include?(status)
  end

  def is_verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end

  def validate_status
    return if (is_verified_role(:client) && valid_client_status?) || (is_verified_role(:influencer) && valid_influencer_status?)

    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
  end

  def seller_navbar
    return if verified_role.is_a? Client

    @navbar = 'shared/navbar/seller_navbar'
  end

  def scoped_orders
    if verified_role.is_a? Influencer
      GigClient.joins(:gig, :client).where(
        gigs: {influencer_id: current_user.influencer.id}).includes(:gig, :client, :gig_package
      ) || []
    elsif verified_role.is_a? Client
      current_user.client.gig_clients
    end
  end
end
