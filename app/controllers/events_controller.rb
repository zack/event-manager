class EventsController < ApplicationController
  RSVP_NO = -1
  RSVP_MAYBE = 0
  RSVP_YES = 1
  RSVP_YES_AND_ONE = 2
  RSVP_YES_AND_TWO = 3
  RSVP_YES_AND_THREE = 4

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

    event_time = params['event']['datetime'].split(/[- :]/).map { |n| n.to_i }
    @event.datetime = DateTime.new(*event_time)

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
    @rsvp_count = Rsvp.where(event: @event, response: true).count
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
    @options =
      [
        { 'option' => 'No', 'value' => RSVP_NO },
        { 'option' => 'Maybe', 'value' => RSVP_MAYBE },
        { 'option' => 'Yes', 'value' => RSVP_YES },
        { 'option' => 'Yes + 1', 'value' => RSVP_YES_AND_ONE },
        { 'option' => 'Yes + 2', 'value' => RSVP_YES_AND_TWO },
        { 'option' => 'Yes + 3', 'value' => RSVP_YES_AND_THREE }
      ]
    @options_for_select = @options.map { |o| [o['option'], o['value']] }
  end

  def submit_rsvp
    @event = Event.find_by uuid: params[:uuid]
    @user = User.find_by uuid: params[:user][:uuid]
    rsvp = params[:RSVP]
    # TODO: CREATE RSVP CONTROLLER AND CREATE RSVPS
    redirect_to action: :rsvp, user_uuid: @user.uuid
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
        :subscription_list_id,
        :uuid
      )
    end
end
