# frozen_string_literal: true

class BaseMailer < ApplicationMailer
  SUBJECT = 'NEW Message from Bazaar'

  private

  def user(id)
    @user ||= User.find(id)
  end

  def to_email(id)
    user(id).email
  end

  def to_date(date_time)
    DateTime.parse(date_time).strftime('%B %d, %Y') if date_time.present?
  end
end
