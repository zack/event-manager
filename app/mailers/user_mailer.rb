class UserMailer < ApplicationMailer
  def ad_hoc_send(user, subject, body)
    @user = user
    @body = body
    mail to: @user.email_address, subject: "#{ENV.fetch("MAILING_LIST_NAME")}: #{subject}"
  end

  def new_user_email(user)
    @user = user
    @subscription_names = Subscription.where(user_id: @user).map do |s|
      SubscriptionList.find(s.subscription_list_id).name
    end
    mail to: "#{ENV.fetch('EMAIL_USER')}@#{ENV.fetch('EMAIL_DOMAIN')}", subject: "#{ENV.fetch('MAILING_LIST_NAME')} New User Registered"
  end

  def deleted_user_email(user)
    @user = user
    mail to: "#{ENV.fetch('EMAIL_USER')}@#{ENV.fetch('EMAIL_DOMAIN')}", subject: "#{ENV.fetch('MAILING_LIST_NAME')} User Self-Deleted"
  end

  def destroyed_user_email(user_name, user_email)
    @user_name = user_name
    @user_email = user_email
    mail to: "#{ENV.fetch('EMAIL_USER')}@#{ENV.fetch('EMAIL_DOMAIN')}", subject: "#{ENV.fetch('MAILING_LIST_NAME')} User Deleted"
  end

  def confirmation_email(user)
    @user = user
    @subscription_names = Subscription.where(user_id: @user).map do |s|
      SubscriptionList.find(s.subscription_list_id).name
    end
    mail to: @user.email_address, subject: "#{ENV.fetch('MAILING_LIST_NAME')} Email Confirmation [CLICK REQUIRED]"
  end

  def change_email_address_email(user)
    @user = user
    mail to: @user.email_address, subject: "#{ENV.fetch('MAILING_LIST_NAME')} Email Address Change Confirmation [CLICK REQUIRED]"
  end

  def recover_account(user)
    @user = user
    mail to: @user.email_address, subject: "#{ENV.fetch('MAILING_LIST_NAME')} Account Recovery"
  end

  def invite(user, event)
    @user = user
    @event = event

    # send an email
    if user.email_address
      if @event.address_id
        @address = Address.find(@event.address_id)
      end
      @subscription_list_name = SubscriptionList.find(@event.subscription_list_id).name
      datetime = @event.datetime.strftime('%-m/%-d at %-l:%M%p')
      subject = "#{ENV.fetch('MAILING_LIST_NAME')}: Invitation for #{@subscription_list_name} on #{datetime}"
      attachments['invite.ics'] = { mime_type: 'text/calendar', content: @event.create_ics(@user) }
      mail to: @user.email_address, subject: subject
    end

    # send a text
    if user.phone_number
      client = Twilio::REST::Client.new
      rsvp_url = url_for controller: 'events', action: 'rsvp', uuid: @event.uuid, user_uuid: user.uuid
      client.messages.create(
        from: ENV.fetch('TWILIO_PHONE_NUMBER'),
        to: user.phone_number,
        body: "Hey, you've been invited to a new Berkeley Events event. Check it out and RSVP here: #{rsvp_url}"
      )
    end
  end

  def invite_special(guest, special_event)
    @special_event = special_event
    date = @special_event.datetime.strftime('%-m/%-d')
    subject = "#{@special_event.name} (#{date}) [EVENT INVITATION]"
    attachments['invite.ics'] = { mime_type: 'text/calendar', content: @special_event.create_ics(guest) }
    mail to: guest.email_address, from: 'zack@youngren.io', subject: subject
  end

  def event_updated(user, new_event, old_event)
    @user = user
    @new_event = new_event
    @old_event = old_event

    @subscription_list_name = SubscriptionList.find(@new_event.subscription_list_id).name
    subject = "#{ENV.fetch('MAILING_LIST_NAME')}: Event updated for #{@subscription_list_name}"
    mail to: @user.email_address, from: "#{ENV.fetch('SPECIAL_EMAIL_USER')}@#{ENV.fetch('SPECIAL_EMAIL_DOMAIN')}", subject: subject
  end

  def event_deleted(user, event, reason)
    @user = user
    @event = event
    @reason = reason
    @subscription_list_name = SubscriptionList.find(@event.subscription_list_id).name
    datetime = @event.datetime.strftime('%-m/%-d at %-l:%M%p')
    subject = "#{ENV.fetch('MAILING_LIST_NAME')}: Event deleted for #{@subscription_list_name} on #{datetime}"
    mail to: @user.email_address, subject: subject
  end

  def special_event_deleted(guest, special_event)
    @special_event = special_event
    datetime = @event.datetime.strftime('%-m/%-d')
    subject = "#{special_event.name} (#{date}) [EVENT CANCELLED]"
    mail to: guest.email_address, subject: subject
  end
end
