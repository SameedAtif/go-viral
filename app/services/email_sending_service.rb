# frozen_string_literal: true

class EmailSendingService
  attr_reader :notification, :notification_type

  def initialize(notification)
    @notification = notification
    @notification_type = @notification.type
  end

  def generate
    return unless mailer

    mailer.send(mailer_method, notification).deliver_later
  end

  private

  def mailer
    @mailer ||= if CreatorMailer.respond_to? mailer_method
                  CreatorMailer
                elsif ReviewerMailer.respond_to? mailer_method
                  ReviewerMailer
                elsif ClientMailer.respond_to? mailer_method
                  ClientMailer
                end
  end

  def mailer_method
    @mailer_method ||= "#{notification_type}_email"
  end
end
