# frozen_string_literal: true

require 'active_support/concern'

module EmailHandler
  extend ActiveSupport::Concern

  included do
    after_commit :send_email, on: :create
  end

  private

  def send_email
    EmailSendingService.new(self).generate
  end
end
