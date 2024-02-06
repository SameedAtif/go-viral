class Users::RegistrationsController < Devise::RegistrationsController
  layout "offline"
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_influencer, only: %i[edit update]
  before_action :set_organization, only: %i[edit update]

  def edit
    super
  end

  def create
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  def set_influencer
    @influencer = resource.influencer || Influencer.new
    @influencer.influencer_platforms.build
    @influencer.influencer_portfolios.build
  end

  def set_organization
    @organization = current_user.client&.organization || Organization.new
  end
end
