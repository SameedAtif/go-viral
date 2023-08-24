class Users::SessionsController < Devise::SessionsController
  def switch_session
    session[:user_role] = validate_session_type
    redirect_to root_path
  end

  private

  def validate_session_type
    params[:type] == "1" ? User::USER_ROLES[:influencer] : User::USER_ROLES[:client]
  end
end
