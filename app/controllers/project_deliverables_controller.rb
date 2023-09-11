class ProjectDeliverablesController < ApplicationController
  before_action :load_project_milestone, except: :update
  before_action :authorize_resource!, only: :update

  def create
    @project_deliverable = ProjectDeliverable.new(permitted_params)
    @project_deliverable.project_milestone_id = @project_milestone.id
    @project_deliverable.influencer_id = current_user.influencer.id
    authorize @project_deliverable
    @project_deliverable.save!
    redirect_to @project_milestone
  end

  def update
    @project_deliverable.update!(permitted_params)
  end

  private

  def permitted_params
    params.require(:project_deliverable).permit(:title, :description)
  end

  def load_project_milestone
    @project_milestone = ProjectMilestone.find(params[:project_milestone_id])
  end

  def authorize_resource!
    @project_deliverable = ProjectDeliverable.find(params[:id])
    authorize @project_deliverable
  end
end
