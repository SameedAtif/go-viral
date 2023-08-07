class ProjectDeliverablesController < ApplicationController
  def index
    @project_milestone = ProjectMilestone.find(params[:project_milestone_id])
    @project_deliverables = @project_milestone.project_deliverables
  end

  def new
    @project_milestone = ProjectMilestone.find(params[:project_milestone_id])
    @project_deliverable = ProjectDeliverable.new(project_id: params[:project_id])
  end

  def create
    @project_milestone = ProjectMilestone.find(params[:project_milestone_id])
    @project_deliverable = ProjectDeliverable.new(permitted_params)
    @project_deliverable.project_milestone_id = @project_milestone.id
    @project_deliverable.influencer_id = current_user.influencer.id
    @project_deliverable.save!
    redirect_to @project_milestone
  rescue StandardError => e
    flash[:error] = e
    render 'new'
  end

  def update
    project_deliverable = ProjectDeliverable.find(params[:id])
    project_deliverable.update!(permitted_params)
    if session[:user_role] == "Client"
      project_client = current_user.client.projects.find(params[:project_id])
      project_application.update!(status: validate_client_statuses) if project_client.present?
    end
  rescue StandardError => e
    flash[:error] = e
    render 'new'
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
end
