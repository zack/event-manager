class EventsController < ApplicationController
  before_action :require_admin_login, only: [
    :index, :new, :create, :admin, :edit, :update, :delete, :destroy, :syndicate
  ]

  def index
    @events = Event.all.order(datetime: :desc)
    @upcoming_events = @events.select { |e| (e.datetime > DateTime.now) && (not e.deleted) }
    @past_and_deleted_events = @events.select { |e| (e.datetime < DateTime.now) || e.deleted }
  end

  def new
    @event = Event.new
  end

  def clone
    @source = Event.find_by uuid: params['uuid']
    @event = Event.new

    @event.description = @source.description
    @event.location = @source.location
    @event.capacity = @source.capacity
    @event.subscription_list_id = @source.subscription_list_id
    render :new
  end

  def create
    @event = Event.new(event_params)
    @event.uuid = SecureRandom.uuid

    if @event.save
      redirect_to action: :edit, uuid: @event.uuid
    else
      @event.uuid = nil
      render :new
    end
  end

  def admin
    @event = Event.find_by uuid: params['uuid']

    subscribed_users = User
      .includes(:subscription_lists)
      .where(subscription_lists: { id: @event.subscription_list_id })

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

    if @event.deleted
      flash[:warning] = 'This event has been soft deleted.'
    end
  end

  def show
    @event = Event.find_by uuid: params['uuid']
    @rsvp_count = Rsvp.where(event_id: @event).where('response > ?', 0).count

    if @event.deleted
      flash[:warning] = 'This event has been cancelled! Sorry!'
    end

    if @event.created_at != @event.updated_at
      flash[:notice] = @event.updated_at.strftime('This event has been updated. It was last updated on %b %d at %I:%M%p')
    end
  end

  def edit
    @event = Event.find_by uuid: params['uuid']
  end

  def update
    @event = Event.find_by uuid: params['event']['uuid']

    if @event.update(event_params)
      flash[:success] = 'Event successfully updated!'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def rsvp
    @event = Event.find_by uuid: params[:uuid]
    @user = User.find_by uuid: params[:user_uuid]
    @options_for_select = Rsvp::RESPONSE_STRINGS_BY_VALUE.map { |k, v| [v, k] }
    @existing_rsvp_value = Rsvp.find_by(event_id: @event, user_id: @user)&.response || false

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

    if params[:RSVP] == nil
      rsvp.delete
      return (redirect_to action: :rsvp, user_uuid: params[:user][:uuid])
    else
      flash[:success] = 'RSVP received. Thank you!'
      rsvp.update(response: params[:RSVP])
      redirect_to action: :rsvp, user_uuid: params[:user][:uuid]
    end
  end

  def delete
    @event = Event.find_by uuid: params[:uuid]
  end

  def soft_delete
    @event = Event.find_by uuid: params['uuid']
    @event.update(deleted: true)
    flash[:success] = 'Event successfully soft deleted!'
    redirect_to action: :index
  end

  def syndicate_preview
    @event = Event.find_by uuid: params['uuid']
    @users = get_users_for_event_syndication(@event)
  end

  def syndicate
    @event = Event.find_by uuid: params['uuid']
    @users = get_users_for_event_syndication(@event)
    @users.each do |u|
      UserMailer.invite(u, @event).deliver_now
      Syndication.create(
        event_id: @event.id,
        user_id: u.id
      )
    end

    flash[:succes] = "Successfully invited #{@users.count} users!"
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
        :capacity,
        :datetime,
        :description,
        :location,
        :subscription_list_id,
        :uuid
      )
    end
end
