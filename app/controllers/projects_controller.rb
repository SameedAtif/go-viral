class ProjectsController < ApplicationController
  def new
    @project = Project.new
    @project.project_platforms.build
    @project.project_categories.build
    @project.project_milestones.build
    @project.example_works.build
  end

  def create
    @project = Project.new(permitted_params)
    @project.client = current_user.client
    @project.save!
    flash[:success] = 'Campaign successfully created'
    redirect_to root_path
  rescue StandardError => e
    flash[:error] = e
    render 'new'
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = current_user.client.projects.find(params[:id])
  end

  def update
    @project = current_user.client.projects.find(params[:id])
    @project.update!(permitted_params)
    redirect_to @project
  rescue StandardError => e
    flash[:error] = e
    render 'edit'
  end

  def destroy; end

  private

  def permitted_params
    params.require(:project).permit(
      :id, :title, :description, :budget, :start_time, :end_time,
      :required_number_of_influencers, :status, :payment_type,
      :target_audience, :is_draft, :reviewed,
      project_platforms_attributes: %i[id platform_id _destroy],
      project_categories_attributes: %i[id category_id _destroy]
      project_milestones_attributes: %i[id title description reach conversion budget _destroy],
      example_works_attributes: %i[id title description _destroy]
    )
  end
end
