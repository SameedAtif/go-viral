class Users::SessionsController < Devise::SessionsController
  def switch_session
    session[:user_role] = validate_session_type
    redirect_to root_path
  end

  def destroy
    ActionCable.server.remote_connections.where(current_user: current_user).disconnect
    current_user.update(status: User.statuses[:offline])
    super
  end

  private

  def validate_session_type
    params[:type] == "1" ? User::USER_ROLES[:influencer] : User::USER_ROLES[:client]
  end
end
