class SubscriptionListsController < ApplicationController
  before_action :require_admin_login

  def index
    @lists = SubscriptionList.all.to_a
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
    list = SubscriptionList.find(subscription_list_params[:id])
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
