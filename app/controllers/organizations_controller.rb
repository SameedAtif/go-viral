class OrganizationsController < ApplicationController
  def new; end

  def create
    Organization.transaction do
      organization = Organization.create!(create_params)
      client = Client.find_or_create_by!(user: current_user)
      session[:user_role] = 'Client'
      OrganizationDetail.find_or_create_by!(organization: organization, client: client, client_role: 'Owner')
    end
    flash[:success] = "Organization successfully created"
    redirect_to root_path
  rescue StandardError => e
    flash[:error] = e
    redirect_to root_path
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  def create_params
    params.require(:organization).permit(:name, :address_1, :address_2, :city, :country, :phone_number)
  end
end
