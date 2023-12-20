class ApplicationMailer < ActionMailer::Base
  default from: "Bazaar Support <#{ENV['SMTP_DEFAULT_FROM'] || 'greenlight@thecreatorsbazaar.com'}>"
  layout "mailer"
end
