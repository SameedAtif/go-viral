class ProjectsController < ApplicationController
  before_action :load_project, except: %i[create new]
  before_action :authorize_resource!, except: %i[create new show]
  skip_before_action :authenticate_user!, only: :show
  before_action :validate_status, only: %i[create update]

  def new
    @project = Project.new
    authorize @project
    @project.project_platforms.build
    @project.project_categories.build
    @project.project_milestones.build
    @project.example_works.build
  end

  def create
    @project = Project.new(creation_params)
    @project.organization = current_user.client.organization
    authorize @project
    @project.save!
    flash[:success] = 'Campaign successfully created'
    redirect_to root_path
  end

  def show; end

  def edit; end

  def update
    @project.update!(permitted_params)
    redirect_to @project
  end

  def destroy; end

  private

  def creation_params
    params.require(:project).permit(
      :title, :description, :budget, :start_time, :end_time,
      :required_number_of_influencers, :payment_type,
      :targeted_demographic_start_age, :targeted_demographic_end_age,
      :is_draft, targeted_geographic_audience: [],
      project_platforms_attributes: %i[platform_id _destroy],
      project_categories_attributes: %i[category_id _destroy],
      project_milestones_attributes: %i[title description reach conversion budget start_time end_time _destroy],
      example_works_attributes: %i[title description _destroy]
    )
  end

  def permitted_params
    params.require(:project).permit(
      policy(@project).permitted_attributes
    )
  end

  def load_project
    @project = Project.find(params[:id])
  end

  def authorize_resource!
    authorize @project
  end

  def valid_client_status?
    status = params.dig(:project, :status)
    return true if status.blank?

    [::Project::STATUSES_MAP[:published], ::Project::STATUSES_MAP[:cancelled]].include?(status)
  end

  def valid_reviewer_status?
    status = params.dig(:project, :status)
    return true if status.blank?

    [::Project::STATUSES_MAP[:approved], ::Project::STATUSES_MAP[:rejected]].include?(status)
  end

  def verified_role(user_type)
    role = current_user.send(user_type)

    role.present? && session[:user_role] == User::USER_ROLES[user_type]
  end

  def validate_status
    return if (verified_role(:client) && valid_client_status?) || (verified_role(:reviewer) && valid_reviewer_status?)

    raise Pundit::NotAuthorizedError.new("Unauthorized value for column status")
  end
end
