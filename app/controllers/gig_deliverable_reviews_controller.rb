class GigDeliverableReviewsController < ApplicationController
  before_action :load_gig_deliverable, except: :update
  before_action :authorize_resource!, only: :update

  def create
    @gig_deliverable_review = GigDeliverableReview.new(permitted_params)
    @gig_deliverable_review.gig_deliverable_id = @gig_deliverable.id
    @gig_deliverable_review.gig_client_id = @gig_deliverable.gig_client.id
    @gig_deliverable_review.client_id = @gig_deliverable.gig_client.client.id

    authorize @gig_deliverable_review
    @gig_deliverable_review.save!
    @gig_deliverable.update(active: false)
    redirect_to @gig_deliverable_review, notice: "Delivery review created"
  end

  def update
    @gig_deliverable_review.update!(permitted_params)
    redirect_to @gig_deliverable_review.gig_deliverable.gig_client, notice: "Delivery review updated"
  end

  private

  def permitted_params
    params.require(:gig_deliverable_review).permit(
      :id, :remarks, :rating, :status)
  end

  def load_gig_deliverable
    @gig_deliverable = GigDeliverable.find(params[:gig_deliverable_id])
  end

  def authorize_resource!
    @gig_deliverable_review = GigDeliverableReview.find(params[:id])
    authorize @gig_deliverable_review
  end
end
