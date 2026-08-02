class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV.fetch('EMAIL_USER', 'notifier')}@#{ENV.fetch('EMAIL_DOMAIN', 'example.com')}"

  layout 'mailer'
end
