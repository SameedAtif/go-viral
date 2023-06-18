class Users::SessionsController < Devise::SessionsController
  def switch_session
    session[:user_role] = validate_session_type
    redirect_to root_path
  end

  private

  def validate_session_type
    user_type = params[:type] == "1" ? 'Influencer' : 'Client'
    ['Influencer', 'Client'].find{ |type| type == user_type }
  end
end
