class ProjectApplicationsController < ApplicationController
  before_action :set_project, only: %i[index new create]
  before_action :set_project_application, only: :update

  def index
    @project_applications = policy_scope(@project.project_applications)
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
    if (verified_role(:client) && valid_client_status?) || (verified_role(:influencer) && valid_creator_status?)
      @project_application.update!(permitted_params)
    else
      raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
    end
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

  def valid_creator_status?
    status = params.dig(:project_application, :status)
    return true if status.blank?

    ['draft', 'ready_for_review'].include?(status)
  end

  def valid_client_status?
    status = params.dig(:project_application, :status)
    return true if status.blank?

    ['approved', 'rejected'].include?(status)
  end

  def verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end
end
