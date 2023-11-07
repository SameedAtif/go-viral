class GigDeliverablesController < ApplicationController
  before_action :load_gig_client, except: :update
  before_action :authorize_resource!, only: :update

  def create
    @gig_deliverable = GigDeliverable.new(permitted_params)
    @gig_deliverable.gig_client = @gig_client
    authorize @gig_deliverable
    @gig_deliverable.save!
    redirect_to @gig_deliverable
  end

  def update
    @gig_deliverable.update!(permitted_params)
  end

  private

  def permitted_params
    params.require(:gig_deliverable).permit(:title, :description)
  end

  def load_gig_client
    @gig_client = GigClient.find(params[:gig_client_id])
  end

  def authorize_resource!
    @gig_deliverable = GigDeliverable.find(params[:id])
    authorize @gig_deliverable
  end
end
