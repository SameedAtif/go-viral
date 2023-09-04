class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    params.require(:sign_up).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
