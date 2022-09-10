class EventsController < ApplicationController
  before_action :require_admin_login, only: [
    :index, :new, :create, :admin, :edit, :update, :delete, :destroy, :syndicate, :invite_user
  ]

  def index
    @events = Event.all.order(datetime: :desc)
    @upcoming_events = @events.select { |e| (e.datetime_end > DateTime.now) && (not e.deleted) }
    @deleted_events = @events.select { |e| e.deleted }
    @past_events = @events.select { |e| (e.datetime < DateTime.now) && !e.deleted }
  end

  def new
    @event = Event.new
  end

  def clone
    @source = Event.find_by uuid: params['uuid']
    @event = Event.new

    @event.description = @source.description
    @event.address_id = @source.address_id
    @event.capacity = @source.capacity
    @event.subscription_list_id = @source.subscription_list_id
    render :new
  end

  def create
    @event = Event.new(event_params)
    @event.uuid = SecureRandom.uuid

    if @event.save
      redirect_to action: :admin, uuid: @event.uuid
    else
      @event.uuid = nil
      render :new
    end
  end

  def admin
    @event = Event.find_by uuid: params['uuid']

    @options_for_rsvp_select = Rsvp::RESPONSE_STRINGS_BY_VALUE.map { |k, v| [v, k] }.insert(0, '')

    ### DATA COPY-PASTED FOR MODERATORS IN #RSVP ###

    @existing_rsvp_values =
        Hash[User.all.collect {
          |u| [u.id, Rsvp.find_by(event_id: @event, user_id: u)&.response || false]
        }]

    subscribed_users = User
      .includes(:subscription_lists)
      .where(subscription_lists: { id: @event.subscription_list_id })
      .sort_by { |u| u.first_name }

    # split users into those that are:
    # * eligible for invites (confirmed)
    # * ineligible for invites (unconfirmed)
    confirmed, @unconfirmed = subscribed_users.partition do |s|
      s.email_confirmed && s.admin_confirmed
    end

    # split all eligible users into
    # * already invited (and possibly responded)
    # * not invited
    @invited, @not_invited = confirmed.partition do |s|
      Syndication.where(event_id: @event, user_id: s).count > 0
    end

    # but we don't want users that have already responded in this array
    @invited = @invited.filter do |u|
      Rsvp.where(event_id: @event, user_id: u).count == 0
    end

    ### END DATA COPY-PASTED FOR MODERATORS IN #RSVP ###

    if @event.deleted
      flash[:warning] = 'This event has been soft deleted.'
    end
  end

  def show
    @event = Event.find_by uuid: params['uuid']
    @address = Address.find(@event.address_id)

    check_past_or_deleted(@event)

    if @event.created_at != @event.updated_at
      flash[:notice] = @event.updated_at.strftime('This event has been updated. It was last updated on %b %d at %I:%M%p')
    end
  end

  def edit
    @event = Event.find_by uuid: params['uuid']
  end

  def update
    @event = Event.find_by uuid: params['event']['uuid']

    old_event = @event.attributes
    @event.assign_attributes(event_params)
    event_changed = @event.changed?

    if @event.save
      if event_changed && params[:suppress_email] == '1'
        flash[:success] = 'Event successfully updated! Update email suppressed.'
      elsif event_changed
        users = User.includes(:syndications).where(syndications: { event_id: @event })
        users.each do |u|
          UserMailer.event_updated(u, @event, old_event).deliver_later
        end
        user_string = ActionController::Base.helpers.pluralize(users.count, 'user')
        flash[:success] = "Event successfully updated! Notified #{user_string}."
      else
        flash[:notice] = 'No changes detected.'
      end
      redirect_to action: :index
    else
      render :edit
    end
  end

  def check_past_or_deleted(event)
    if event.deleted
      render :deleted
      return
    end

    if event.datetime < DateTime.now - 24.hours
      render :past
    end
  end

  def rsvp
    @event = Event.find_by uuid: params[:uuid]
    check_past_or_deleted(@event)
    @user = User.find_by uuid: params[:user_uuid]
    @address = Address.find(@event.address_id)
    @options_for_select = Rsvp::RESPONSE_STRINGS_BY_VALUE.map { |k, v| [v, k] }.insert(0, '')
    @existing_rsvp_value = Rsvp.find_by(event_id: @event, user_id: @user)&.response || false

    ### DATA FOR MODERATORS, COPY-PASTED FROM ADMIN ###
    @existing_rsvp_values =
        Hash[User.all.collect {
          |u| [u.id, Rsvp.find_by(event_id: @event, user_id: u)&.response || false]
        }]

    subscribed_users = User
      .includes(:subscription_lists)
      .where(subscription_lists: { id: @event.subscription_list_id })

    confirmed, @unconfirmed = subscribed_users.partition do |s|
      s.email_confirmed && s.admin_confirmed
    end

    # split all eligible users into
    # * already invited (and possibly responded)
    # * not invited
    @invited, @not_invited = confirmed.partition do |s|
      Syndication.where(event_id: @event, user_id: s).count > 0
    end

    # but we don't want users that have already responded in this array
    @invited = @invited.filter do |u|
      Rsvp.where(event_id: @event, user_id: u).count == 0
    end

    ### END DATA FOR MODERATORS, COPY-PASTED FROM ADMIN ###

    if @event.deleted
      flash[:warning] = 'This event has been cancelled! Sorry!'
    end

    if @event.created_at != @event.updated_at
      flash[:notice] = @event.updated_at.strftime('This event has been updated. It was last updated on %b %d at %I:%M%p')
    end
  end

  def submit_rsvp
    event = Event.find_by uuid: params[:uuid]
    user = User.find_by uuid: params[:user][:uuid]
    rsvp = Rsvp.find_or_create_by(
      'event_id' => event.id,
      'user_id' => user.id
    )

    rsvp_count = [params[:RSVP].to_i || 0, 0].max
    if params[:RSVP] == '0'
      # If the response was "maybe" treat it as a "yes"
      rsvp_count = 1
    end


    if params[:RSVP] == nil
      rsvp.delete
      (redirect_to action: :rsvp, user_uuid: params[:user][:uuid])
    elsif event.capacity == nil || event.attendees + rsvp_count <= event.capacity
      rsvp.update(response: params[:RSVP])
      if session[:admin] && params[:admin] && params[:admin][:true] == 'true'
        flash[:success] = "#{user.name} RSVP updated to: #{rsvp.get_rsvp_as_string}"
        redirect_to action: :admin, event: params[:uuid]
      else
        flash[:success] = 'RSVP received. Thank you!'
        redirect_to action: :rsvp, user_uuid: params[:user][:uuid]
      end
    else
      flash[:warning] = 'Sorry, this RSVP would put the event over capacity.'
      redirect_to action: :rsvp, user_uuid: params[:user][:uuid]
    end
  end

  def delete
    @event = Event.find_by uuid: params[:uuid]
  end

  def soft_delete
    @event = Event.find_by uuid: params['uuid']
    @event.update(deleted: true)

    @event = Event.find_by uuid: params['uuid']
    users = User.includes(:syndications).where(syndications: { event_id: @event })
    users.each do |u|
      UserMailer.event_deleted(u, @event).deliver_later
    end

    user_string = ActionController::Base.helpers.pluralize(users.count, 'user')
    flash[:success] = "Event successfully soft deleted! Notified #{user_string}."
    redirect_to action: :index
  end

  def syndicate_preview
    @event = Event.find_by uuid: params['uuid']
    @address = Address.find(@event.address_id)
    @users = get_users_for_event_syndication(@event)
  end

  def syndicate
    @event = Event.find_by uuid: params['uuid']
    @users = get_users_for_event_syndication(@event)
    @users.each do |u|
      UserMailer.invite(u, @event).deliver_later
      Syndication.create(
        event_id: @event.id,
        user_id: u.id
      )
    end

    flash[:succes] = "Successfully invited #{@users.count} users!"
    redirect_to action: :admin, uuid: @event.uuid
  end

  def invite_user
    @user = User.find(params['user_id'])
    @event = Event.find(params['event_id'])
    UserMailer.invite(@user, @event).deliver_now
    Syndication.create(event_id: @event.id, user_id: @user.id)
    redirect_to action: :admin, uuid: @event.uuid
  end

  private

    def get_users_for_event_syndication(event)
      users = User
        .includes(:subscription_lists)
        .includes(:syndications)
        .where(users: { email_confirmed: true })
        .where(users: { admin_confirmed: true })
        .where(subscription_lists: { id: @event.subscription_list_id })

      # there's probably a way to do this in the above query, but this works
      @users = users.filter do |u|
        Syndication.where(user_id: u, event_id: @event).count == 0
      end
    end

    def event_params
      params.require(:event).permit(
        :address_id,
        :capacity,
        :datetime,
        :datetime_end,
        :description,
        :subscription_list_id,
        :uuid
      )
    end
end
