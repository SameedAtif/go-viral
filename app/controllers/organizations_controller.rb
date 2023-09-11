class OrganizationsController < ApplicationController
  before_action :load_organization, except: %i[create new]
  before_action :authorize_resource!, except: %i[create show]
  skip_before_action :authenticate_user!, only: :show

  def new; end

  def create
    Organization.transaction do
      organization = Organization.create!(creation_params)
      client = Client.find_or_create_by!(user: current_user)
      session[:user_role] = User::USER_ROLES[:client]
      OrganizationDetail.find_or_create_by!(organization: organization, client: client, client_role: OrganizationDetail::CLIENT_ROLES_MAP[:owner])
    end
    flash[:success] = "Organization successfully created"
    redirect_to root_path
  end

  def show; end

  def edit; end

  def update
    @organization.update!(permitted_params)
    flash[:success] = "Organization updated"
    redirect_to organization_path
  end

  def destroy; end

  private

  def creation_params
    params.require(:organization).permit(
      :name, :address_1, :address_2, :city, :country, :phone_number,
      :website_url, :facebook_url, :instagram_url, :tiktok_url, :youtube_url
    )
  end

  def permitted_params
    params.require(:organization).permit(
      policy(@organization).permitted_attributes
    )
  end

  def load_organization
    @organization = Organization.find(params[:id])
  end

  def authorize_resource!
    authorize @organization
  end
end
