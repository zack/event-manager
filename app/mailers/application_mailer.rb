class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV.fetch('EMAIL_USER')}@#{ENV.fetch('EMAIL_DOMAIN')}"

  layout 'mailer'
end
