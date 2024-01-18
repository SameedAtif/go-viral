class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  helper_method :verified_role

  def pundit_user
    current_role = User::USER_ROLES[
      (session[:user_role] || 'user').downcase.to_sym
    ]
    UserContext.new(current_user, current_role)
  end

  def verified_role
    role = current_user.send(session[:user_role])

    role if role.present? && session[:user_role] == User::USER_ROLES[session[:user_role].to_sym]
  end
end
