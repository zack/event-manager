class UserMailer < ApplicationMailer
  def confirmation_email(subscriber)
    @subscriber = subscriber
    mail to: @subscriber.email_address, subject: 'Saturday Night Board Games Email Confirmation'
  end
end
