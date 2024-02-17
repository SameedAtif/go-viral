module NotificationsHelper
  def approved_notifications
    ::Notification::NOTIFICATION_TYPES.select { |noti| noti.include?('approved') || noti.include?('credited') }
  end

  def pending_work_notifications
    ::Notification::NOTIFICATION_TYPES.select do |notif|
      noti.include?('rejected') || noti.include?('dispute') || noti.include?('debited')
    end
  end

  def notification_icon(notification_type)
    case notification_type
    when *approved_notifications
      "shared/svgs/success"
    else
      "shared/svgs/warning"
    end
  end
end
