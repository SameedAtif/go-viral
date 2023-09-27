class SystemProjectTransactionsController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      permitted_params[:project_applications].each do |application_id|
        resource = SystemProjectTransaction.new(project_application_id: application_id)
        resource.project = resource.project_application.project
        resource.client = current_user.client
        resource.gross_price = resource.project_application.budget
        resource.fee = 0.00
        resource.transaction_token = "ABC"
        resource.transaction_type = "credit"
        resource.save!
      end
    end
  end

  private

  def permitted_params
    params.require(:system_project_transaction).permit(project_applications: [:id])
  end
end
