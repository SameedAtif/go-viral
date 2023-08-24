class UserContext
  attr_reader :user, :current_role

  def initialize(user, current_role)
    @user = user
    @current_role = current_role
  end
end
