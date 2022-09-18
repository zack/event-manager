class SubscriptionListsController < ApplicationController
  before_action :require_admin_login

  include Rails.application.routes.url_helpers

  def index
    @lists = SubscriptionList.all.to_a
  end

  def show
    @list = SubscriptionList.find_by id: params['id']
    @users = User.includes(:subscription_lists).where(subscription_lists: { id: params['id'] }).sort_by { |u| u.first_name }
  end

  def new
    @list = SubscriptionList.new
  end

  def create
    @list = SubscriptionList.new(subscription_list_params)

    if @list.save
      redirect_to action: :show, id: @list.id
    else
      @list.id = nil
      render :new
    end
  end

  def update
    params = subscription_list_params
    if params[:id] != ''
      list = SubscriptionList.find(params[:id])
      list.update(params)
    else
      list = SubscriptionList.new(params)
      list.save
    end

    redirect_to :lists
  end

  def edit
    @list = SubscriptionList.find_by id: params['id']
  end

  def delete
    @list = SubscriptionList.find_by id: params['id']
  end

  def destroy
    list = SubscriptionList.find_by id: params['id']
    events = Event.where('subscription_list_id': list.id)
    subscriptions = Subscription.where('subscription_list_id': list.id)

    events.each do |event|
      rsvps = Rsvp.where(event_id: event.id)
      rsvps.each do |rsvp|
        rsvp.delete
      end

      event.delete
    end

    subscriptions.each do |sub|
      sub.delete
    end

    list.delete
    redirect_to :lists
  end

  private
    def subscription_list_params
      params.require(:subscription_list).permit(
        :name,
        :description,
        :id
      )
    end
end
