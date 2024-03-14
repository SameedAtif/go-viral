class GigDisputesController < ApplicationController
  before_action :set_gig_client, only: :create
  before_action :set_dispute, only: :update

  def create
    resource = GigDispute.new(gig_client: @gig_client)
    resource.detail = creation_params[:detail]
    resource.created_by = session[:user_role]
    authorize resource
    resource.save!
    redirect_to @gig_client, notice: "Dispute created"
  end

  def update
    authorize @dispute
    @dispute.update!(permitted_params)
    redirect_to @dispute.gig_client, notice: "Dispute created"
  end

  private

  def permitted_params
    params.require(:gig_dispute).permit(
      policy(@dispute).permitted_attributes
    )
  end

  def creation_params
    params.require(:gig_dispute).permit(:detail)
  end

  def set_dispute
    @dispute = GigDispute.find(params[:id])
  end

  def set_gig_client
    @gig_client = GigClient.find(params[:gig_client_id])
  end
end
