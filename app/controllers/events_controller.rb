class EventsController < ApplicationController
  before_action :require_admin_login, only: [
    :index, :new, :create, :admin, :edit, :update, :delete, :destroy, :syndicate
  ]

  def index
    @events = Event.all.order(datetime: :desc)
    @upcoming_events = @events.select { |e| e.datetime > DateTime.now }
    @past_events = @events.select { |e| e.datetime < DateTime.now }
  end

  def new
    @event = Event.new
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

    users = User
      .includes(:subscription_lists)
      .where(subscription_lists: { id: @event.subscription_list_id })

    confirmed, @unconfirmed = users.partition do |s|
      s.email_confirmed && s.admin_confirmed
    end

    @invited, @not_invited = confirmed.partition do |s|
      Syndication.where(event_id: @event, user_id: s).count > 0
    end
  end

  def show
    @event = Event.find_by uuid: params['uuid']
    @rsvp_count = Rsvp.where(event_id: @event).where('response > ?', 0).count
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

  def destroy
    @event = Event.find_by uuid: params['uuid']
    @event.destroy
    flash[:success] = 'Event successfully deleted!'
    redirect_to action: :index
  end

  def syndicate
    @event = Event.find_by uuid: params['uuid']
  end

  private

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
