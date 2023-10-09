class ProjectDisputesController < ApplicationController
  before_action :set_project, only: :create
  before_action :set_dispute, only: :update

  def create
    resource = ProjectDispute.new(project: @project)
    resource.detail = creation_params[:detail]
    resource.created_by = session[:user_role]
    if session[:user_role] == User::USER_ROLES[:influencer]
      resource.client = @project.organization.owner
      resource.influencer = current_user.influencer
    elsif session[:user_role] == User::USER_ROLES[:client]
      resource.client = current_user.client
      resource.influencer = Influencer.find(creation_params[:influencer_id])
    end
    authorize resource
    resource.save!
  end

  def update
    authorize @dispute
    @dispute.update!(permitted_params)
  end

  private

  def permitted_params
    params.require(:project_dispute).permit(
      policy(@dispute).permitted_attributes
    )
  end

  def creation_params
    params.require(:project_dispute).permit(:detail, :influencer_id)
  end

  def set_dispute
    @dispute = ProjectDispute.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
