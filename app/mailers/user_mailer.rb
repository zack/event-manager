class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail to: @user.email_address, subject: 'Saturday Night Board Games Email Confirmation'
  end
end
