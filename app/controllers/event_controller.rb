class EventController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.uuid = SecureRandom.uuid

    if @event.save
      redirect_to action: :manage, uuid: @event.uuid
    else
      @event.uuid = nil
      render :new
    end
  end

  def manage
    @event = Event.find_by uuid: params['uuid']
  end

  def update
    @event = Event.find_by uuid: params['event']['uuid']
    if @event.update(event_params)
      flash[:success] = 'Event successfully updated!'
      redirect_to action: :index
    else
      render :manage
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

  private

  def event_params
    params.require(:event).permit(
      :capacity,
      :date,
      :description,
      :subscription_list_id,
      :time,
      :uuid
    )
  end
end
