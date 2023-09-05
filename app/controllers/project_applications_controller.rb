class ProjectApplicationsController < ApplicationController
  before_action :set_project, only: %i[index new create]
  before_action :set_project_application, only: :update

  def index
    @project_applications = @project.project_applications
    # authorize @project_applications
  end

  def new
    @project_application = ProjectApplication.new(project_id: params[:project_id])
    authorize @project_application
  end

  def create
    @project_application = ProjectApplication.new(creation_params)
    @project_application.project_id = @project.id
    @project_application.influencer_id = current_user.influencer.id
    authorize @project_application
    @project_application.status = "in-review"
    @project_application.save!
    redirect_to @project
  end

  def update
    authorize @project_application
    # When a client approves or rejects the application.
    @project_application.update!(permitted_params)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_application
    @project_application = ProjectApplication.find(params[:id])
  end

  def creation_params
    params.require(:project_application).permit(:title, :description, :budget, :delivery_date)
  end

  def permitted_params
    params.require(:project_application).permit(
      policy(@project_application).permitted_attributes
    )
  end
end
