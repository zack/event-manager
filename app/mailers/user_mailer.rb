class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail to: @user.email_address, subject: "#{ENV.fetch('MAILING_LIST_NAME')} Email Confirmation"
  end

  def change_email_address_email(user)
    @user = user
    mail to: @user.email_address, subject: "#{ENV.fetch('MAILING_LIST_NAME')} Email Address Change Confirmation"
  end

  def recover_account(user)
    @user = user
    mail to: @user.email_address, subject: "#{ENV.fetch('MAILING_LIST_NAME')} Account Recovery"
  end
end
