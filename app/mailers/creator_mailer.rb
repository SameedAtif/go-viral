# frozen_string_literal: true

class CreatorMailer < BaseMailer
  def creator_project_amount_credited_mail
    mail(to: to_email(notification.user_id), subject: 'You have been credited')
  end
end
