class Users::SessionsController < Devise::SessionsController
  layout "offline"

  after_action :set_user_type, only: :create

  def switch_session
    session[:user_role] = validate_session_type
    redirect_to redirect_path
  end

  def destroy
    ActionCable.server.remote_connections.where(current_user: current_user).disconnect
    current_user.update(status: User.statuses[:offline])
    reset_session
    super
  end

  private

  def validate_session_type
    params[:type] == "1" ? User::USER_ROLES[:influencer] : User::USER_ROLES[:client]
  end

  def redirect_path
    if params[:type] == "1"
      manage_gigs_gigs_path
    elsif params[:type] == "2"
      manage_orders_gig_clients_path
    end
  end

  def set_user_type
    session[:user_role] = if current_user.influencer.present?
                            User::USER_ROLES[:influencer]
                          elsif current_user.client.present?
                            User::USER_ROLES[:client]
                          end
  end
end
