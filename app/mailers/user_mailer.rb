class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail to: @user.email_address, subject: 'Mailing List Name Placeholder Email Confirmation'
  end
end
