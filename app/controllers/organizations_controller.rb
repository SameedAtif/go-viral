class OrganizationsController < ApplicationController
  def new; end

  def create
    Organization.transaction do
      organization = Organization.create!(creation_params)
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

  def show
    @organization = current_user.client.organization
  end

  def edit
    @organization = current_user.client.organization
  end

  def update
    Organization.update!(permitted_params)
    flash[:success] = "Organization updated created"
    redirect_to organization_path
  rescue StandardError => e
    flash[:error] = e
    redirect_to root_path
  end

  def destroy; end

  private

  def creation_params
    params.require(:organization).permit(:name, :address_1, :address_2, :city, :country, :phone_number)
  end

  def permitted_params
    params.require(:organization).permit(:id, :name, :address_1, :address_2, :city, :country, :phone_number)
  end
end
