class NotificationsController < ApplicationController
  before_action :load_notification, only: %i[update]
  before_action :authorize_resource!, only: %i[update]

  layout "pages_with_search_bar"

  def index
    @notifications = User.last.notifications.order("created_at desc").group_by { |n| n.created_at.strftime("%Y-%m-%d") }
  end

  def update
    @notification.touch(:read_at)
    @notification.touch(:cleared_at) if params[:cleared_at].present?
  end

  def destroy; end

  private

  def authorize_resource!
    authorize @notification
  end

  def load_notification
    @notification = Notification.find(params[:id])
  end
end
