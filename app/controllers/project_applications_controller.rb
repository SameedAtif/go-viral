class ProjectApplicationsController < ApplicationController
  before_action :set_project, only: %i[index new create]
  before_action :set_project_application, only: :update
  before_action :validate_status, only: %i[create update]

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
    @project_application.save!
    redirect_to @project
  end

  def update
    authorize @project_application
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
    params.require(:project_application).permit(:title, :description, :budget, :status, :delivery_date)
  end

  def permitted_params
    params.require(:project_application).permit(
      policy(@project_application).permitted_attributes
    )
  end

  def valid_creator_status?
    status = params.dig(:project_application, :status)
    return true if status.blank?

    [::ProjectApplication::STATUS_TYPES_MAP[:draft], ::ProjectApplication::STATUS_TYPES_MAP[:ready_for_review]].include?(status)
  end

  def valid_client_status?
    status = params.dig(:project_application, :status)
    return true if status.blank?

    [::ProjectApplication::STATUS_TYPES_MAP[:approved], ::ProjectApplication::STATUS_TYPES_MAP[:rejected]].include?(status)
  end

  def verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end

  def validate_status
    return if (verified_role(:client) && valid_client_status?) || (verified_role(:influencer) && valid_creator_status?)

    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
  end
end
