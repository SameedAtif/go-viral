class ProjectApplicationsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @project_applications = @project.project_applications
  end

  def new
    @project = Project.find(params[:project_id])
    @project_application = ProjectApplication.new(project_id: params[:project_id])
  end

  def create
    @project = Project.find(params[:project_id])
    @project_application = ProjectApplication.new(permitted_params)
    @project_application.project_id = @project.id
    @project_application.influencer_id = current_user.influencer.id
    @project_application.status = "in-review"
    @project_application.save!
    redirect_to @project
  rescue StandardError => e
    flash[:error] = e
    render 'new'
  end

  def update
    project_application = ProjectApplication.find(params[:id])
    project_client = current_user.client.projects.find(params[:project_id])
    # When a client approves or rejects the application.
    if session[:user_role] == "Client" && project_client.present?
      project_application.update!(status: validate_client_statuses)
    end
  rescue StandardError => e
    flash[:error] = e
  ensure
    redirect_to project_project_applications_path(params[:project_id])
  end

  private

  def permitted_params
    params.require(:project_application).permit(:title, :description, :budget, :delivery_date)
  end

  def client_update_params
    params.permit(:status)
  end

  def validate_client_statuses
    ['approved', 'rejected'].find{ |type| type == params[:status] }
  end
end
