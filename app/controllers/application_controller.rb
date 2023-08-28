class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  def pundit_user
    current_role = User::USER_ROLES[
      (session[:user_role] || 'user').downcase.to_sym
    ]
    UserContext.new(current_user, current_role)
  end
end
