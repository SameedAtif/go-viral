class ProjectApplicationsController < ApplicationController
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

  private

  def permitted_params
    params.require(:project_application).permit(:title, :description, :budget, :delivery_date)
  end
end
