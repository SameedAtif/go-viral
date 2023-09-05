class NotificationsController < ApplicationController
  def index; end

  def update
    notification.touch(:read_at)
    notification.touch(:cleared_at) if params[:cleared_at].present?
  end

  def destroy; end

  private

  def notification
    authorize Notification.find(params[:id])
  end
end
