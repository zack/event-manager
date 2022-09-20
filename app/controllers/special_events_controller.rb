class SpecialEventsController < ApplicationController
  before_action :require_admin_login, only: [
    :index, :new, :create, :admin, :edit, :update, :delete, :destroy, :syndicate, :invite_user
  ]

  def index
    @special_events = SpecialEvent.all.order(datetime: :desc)
    @upcoming_special_events = @special_events.select { |e| (e.datetime_end > DateTime.now) && (not e.deleted) }
    @deleted_special_events = @special_events.select { |e| e.deleted }
    @past_special_events = @special_events.select { |e| (e.datetime < DateTime.now) && !e.deleted }
  end

  def new
    @special_event = SpecialEvent.new
  end

  def create
    @special_event = SpecialEvent.new(event_params)
    @special_event.uuid = SecureRandom.uuid
    @special_event.deleted = false

    if @special_event.save
      redirect_to action: :admin, uuid: @special_event.uuid
    else
      @special_event.uuid = nil
      render :new
    end
  end

  def edit
    @special_event = SpecialEvent.find_by uuid: params['uuid']
  end

  def update
    @special_event = SpecialEvent.find_by uuid: params['special_event']['uuid']

    old_event = @special_event.attributes
    @special_event.assign_attributes(event_params)
    event_changed = @special_event.changed?

    if @special_event.save
      if event_changed
        flash[:success] = 'Event successfully updated!'
      else
        flash[:notice] = 'No changes detected.'
      end
      redirect_to action: :admin
    else
      render :edit
    end
  end

  def admin
    @special_event = SpecialEvent.find_by uuid: params['uuid']

    guests = SpecialEventSyndication
      .where(special_event_id: @special_event)
      .sort_by { |g| g.email_address } || []
    @uninvited, @invited = guests.partition do |g|
      !g.invited
    end

    bad_addresses = params['bad_addresses']
    if bad_addresses
      @bad_addresses = params['bad_addresses'].join
      flash.now[:warning] = "Some of your addresses didn't pass validation. They've been left in the input box. Try again?"
    end

    if @special_event.deleted
      flash[:warning] = 'This event has been soft deleted.'
    end
  end

  def edit
    @special_event = SpecialEvent.find_by uuid: params['uuid']
  end

  def add_guests
    @special_event = SpecialEvent.find_by uuid: params['uuid']
    addresses = params['addresses'].lines
    bad_addresses = syndicate(@special_event, addresses)
    puts bad_addresses
    redirect_to action: :admin, uuid: @special_event.uuid, bad_addresses: bad_addresses
  end

  def syndicate(special_event, addresses)
    bad_addresses = []

    addresses.each do |address|
      special_event_syndication = SpecialEventSyndication.new
      special_event_syndication.email_address = address.strip
      special_event_syndication.invited = false
      special_event_syndication.rsvp = -2
      special_event_syndication.special_event = special_event

      if special_event_syndication.save
        next
      else
        bad_addresses << address
      end
    end

    bad_addresses
  end

  # def update
  #   @special_event = SpecialEvent.find_by uuid: params['event']['uuid']

  #   old_event = @special_event.attributes
  #   @special_event.assign_attributes(event_params)
  #   event_changed = @special_event.changed?

  #   if @special_event.save
  #     if event_changed && params[:suppress_email] == '1'
  #       flash[:success] = 'SpecialEvent successfully updated! Update email suppressed.'
  #     elsif event_changed
  #       users = User.includes(:syndications).where(syndications: { event_id: @special_event })
  #       users.each do |u|
  #         UserMailer.event_updated(u, @special_event, old_event).deliver_later
  #       end
  #       user_string = ActionController::Base.helpers.pluralize(users.count, 'user')
  #       flash[:success] = "SpecialEvent successfully updated! Notified #{user_string}."
  #     else
  #       flash[:notice] = 'No changes detected.'
  #     end
  #     redirect_to action: :edit
  #   else
  #     render :edit
  #   end
  # end

  def check_past_or_deleted(special_event)
    if special_event.deleted
      render :deleted
      return
    end

    if special_event.datetime_end < DateTime.now
      render :past
    end
  end

  def submit_rsvp
    special_event = SpecialEvent.find_by uuid: params[:uuid]
    invitee = SpecialEventSyndication.find_by email_address: params[:email_address]
    invitee.update(rsvp: params[:rsvp])

    flash[:success] = 'RSVP Updated'
    redirect_to action: :admin, special_event: params[:uuid]
  end

  def delete
    @special_event = SpecialEvent.find_by uuid: params[:uuid]
  end

  def soft_delete
    @special_event = SpecialEvent.find_by uuid: params['uuid']
    @special_event.update(deleted: true)

    invitees = SpecialEventSyndication.where({ special_event_id: @special_event, invited: true })
    invitees.each do |i|
      UserMailer.special_event_deleted(i, @special_event).deliver_later
    end

    invitee_string = ActionController::Base.helpers.pluralize(invitees.count, 'invitee')
    flash[:success] = "Special event successfully soft deleted! Notified #{invitee_string}."
    redirect_to action: :index
  end

  # def syndicate_preview
  #   @special_event = SpecialEvent.find_by uuid: params['uuid']
  #   @address = Address.find(@special_event.address_id)
  #   @users = get_users_for_event_syndication(@special_event)
  # end

  # def syndicate
  #   @special_event = SpecialEvent.find_by uuid: params['uuid']
  #   @users = get_users_for_event_syndication(@special_event)
  #   @users.each do |u|
  #     UserMailer.invite(u, @special_event).deliver_later
  #     Syndication.create(
  #       event_id: @special_event.id,
  #       user_id: u.id
  #     )
  #   end

  #   flash[:succes] = "Successfully invited #{@users.count} users!"
  #   redirect_to action: :admin, uuid: @special_event.uuid
  # end

  def invite_guest
    @special_event = SpecialEvent.find(params[:special_event_id])
    @guest = SpecialEventSyndication.find_by({
      special_event_id: @special_event,
      email_address: params[:email_address],
    })
    # UserMailer.invite(@user, @special_event).deliver_now
    UserMailer.invite_special(@guest, @special_event).deliver_now
    @guest.invited = true
    @guest.save
    redirect_to action: :admin, uuid: @special_event.uuid
  end

  def invite_guests
    @special_event = SpecialEvent.find(params[:special_event_id])
    @guests = SpecialEventSyndication.where({
      invited: false,
      special_event_id: @special_event,
    })
    @guests.each do |guest|
      UserMailer.invite_special(guest, @special_event).deliver_now
      guest.invited = true
      guest.save
    end
    redirect_to action: :admin, uuid: @special_event.uuid
  end

  private

  def get_users_for_event_syndication(event)
    users = User
      .includes(:subscription_lists)
      .includes(:syndications)
      .where(users: { email_confirmed: true })
      .where(users: { admin_confirmed: true })
      .where(subscription_lists: { id: @special_event.subscription_list_id })

    # there's probably a way to do this in the above query, but this works
    @users = users.filter do |u|
      Syndication.where(user_id: u, event_id: @special_event).count == 0
    end
  end

  def event_params
    params.require(:special_event).permit(
      :address_id,
      :capacity,
      :datetime,
      :datetime_end,
      :description,
      :name,
      :uuid
    )
  end
end
