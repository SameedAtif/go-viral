class ProjectDeliverablesController < ApplicationController
  before_action :load_project_milestone, except: :update

  def create
    @project_deliverable = ProjectDeliverable.new(permitted_params)
    @project_deliverable.project_milestone_id = @project_milestone.id
    @project_deliverable.influencer_id = current_user.influencer.id
    @project_deliverable.save!
    redirect_to @project_milestone
  end

  def update
    project_deliverable = ProjectDeliverable.find(params[:id])
    project_deliverable.update!(permitted_params)
    if session[:user_role] == User::USER_ROLES[:client]
      project_client = current_user.client.projects.find(params[:project_id])
      project_application.update!(status: validate_client_statuses) if project_client.present?
    end
  end

  private

  def permitted_params
    params.require(:project_deliverable).permit(:title, :description)
  end

  def client_update_params
    params.permit(:status)
  end

  def validate_client_statuses
    ['approved', 'rejected'].find{ |type| type == params[:status] }
  end

  def load_project_milestone
    @project_milestone = ProjectMilestone.find(params[:project_milestone_id])
  end
end
