class OrganizationsController < ApplicationController
  before_action :load_organization, except: :create
  before_action :authorize_resource!, except: :create

  def new; end

  def create
    Organization.transaction do
      organization = Organization.create!(creation_params)
      client = Client.find_or_create_by!(user: current_user)
      session[:user_role] = User::USER_ROLES[:client]
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

  def update
    organization = Organization.find(params[:id])
    organization.update!(permitted_params)
    flash[:success] = "Organization updated"
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

  def load_organization
    @organization = Organization.find(params[:id])
  end

  def authorize_resource!
    authorize @organization
  end
end
