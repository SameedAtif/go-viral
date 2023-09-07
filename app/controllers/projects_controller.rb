# TODO: Restrict project status to entity
class ProjectsController < ApplicationController
  before_action :load_project, except: %i[create new]
  before_action :authorize_resource!, except: %i[create new show]
  skip_before_action :authenticate_user!, only: :show

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
      :target_audience, :is_draft,
      project_platforms_attributes: %i[platform_id _destroy],
      project_categories_attributes: %i[category_id _destroy],
      project_milestones_attributes: %i[title description reach conversion budget _destroy],
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
end
