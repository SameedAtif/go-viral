class ProjectsController < ApplicationController
  def new
    @project = Project.new
    @project.project_platforms.build
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
    @project = current_user.client.projects.find(params[:id])
  end

  def edit
    @project = current_user.client.projects.find(params[:id])
  end

  def update
    @project = current_user.client.projects.find(params[:id])
    if @project.update(permitted_params)
      redirect_to @project
    else
      flash[:error] = 'Something went wrong'
      render 'edit'
    end
  end

  def destroy; end

  private

  def permitted_params
    params.require(:project).permit(
      :id, :title, :description, :budget,
      project_platforms_attributes: %i[id platform_id _destroy],
      project_milestones_attributes: %i[id title description reach conversion budget _destroy]
    )
  end
end
