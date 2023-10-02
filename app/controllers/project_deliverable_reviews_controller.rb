class ProjectDeliverableReviewsController < ApplicationController
  before_action :load_project_deliverable, except: :update
  before_action :authorize_resource!, only: :update

  def create
    @project_deliverable_review = ProjectDeliverableReview.new(permitted_params)
    @project_deliverable_review.project_deliverable_id = @project_deliverable.id
    @project_deliverable_review.project_id = @project_deliverable.project_milestone.project.id
    @project_deliverable_review.client_id = @project_deliverable.project_milestone.project.organization.owner.id

    authorize @project_deliverable_review
    @project_deliverable_review.save!
    redirect_to @project_deliverable_review
  end

  def update
    @project_deliverable_review.update!(permitted_params)
  end

  private

  def permitted_params
    params.require(:project_deliverable_review).permit(
      :id, :achieved_reach, :achieved_conversion, :remarks,
      :rating, :status)
  end

  def load_project_deliverable
    @project_deliverable = ProjectDeliverable.find(params[:project_deliverable_id])
  end

  def authorize_resource!
    @project_deliverable_review = ProjectDeliverableReview.find(params[:id])
    authorize @project_deliverable_review
  end
end
