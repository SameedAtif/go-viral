class NotificationPolicy < ApplicationPolicy
  def update?
    record.user == user
  end
end
