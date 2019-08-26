class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    @subscription_names = Subscription.where(user_id: @user).map do |s|
      SubscriptionList.find(s.subscription_list_id).name
    end
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

  def invite(user, event)
    @user = user
    @event = event
    @subscription_list_name = SubscriptionList.find(@event.subscription_list_id).name
    datetime = @event.datetime.strftime('%-m/%-d at %-l:%M%p')
    subject = "#{ENV.fetch('MAILING_LIST_NAME')}: Invitation for #{@subscription_list_name} on #{datetime}"
    mail to: @user.email_address, subject: subject
  end
end
