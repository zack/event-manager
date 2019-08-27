class UserMailer < ApplicationMailer
  def ad_hoc_send(user, subject, body)
    @user = user
    @body = body
    mail to: @user.email_address, subject: "#{ENV.fetch("MAILING_LIST_NAME")}: #{subject}"
  end

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

  def event_updated(user, new_event, old_event)
    @user = user
    @new_event = new_event
    @old_event = old_event

    @subscription_list_name = SubscriptionList.find(@new_event.subscription_list_id).name
    subject = "#{ENV.fetch('MAILING_LIST_NAME')}: Event updated for #{@subscription_list_name}"
    mail to: @user.email_address, subject: subject
  end

  def event_deleted(user, event)
    @user = user
    @event = event
    @subscription_list_name = SubscriptionList.find(@event.subscription_list_id).name
    datetime = @event.datetime.strftime('%-m/%-d at %-l:%M%p')
    subject = "#{ENV.fetch('MAILING_LIST_NAME')}: Event deleted for #{@subscription_list_name} on #{datetime}"
    mail to: @user.email_address, subject: subject
  end
end
