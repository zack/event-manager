class MembershipController < ApplicationController

  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(subscriber_params)
    @subscriber.uuid = SecureRandom.uuid
    @subscriber.email_confirmed = false
    @subscriber.admin_confirmed = false
    @subscriber.email_confirmation_code = SecureRandom.hex

    if @subscriber.save
      params['subscriber']['subscription_list_ids'].each do |s|
        new_subscription = SubscriptionList.where(id: s).take
        if new_subscription
          Subscription.create({subscriber_id: @subscriber.id,
                               subscription_list_id: new_subscription.id})
        end
      end

      redirect_to action: :manage, uuid: @subscriber.uuid
    else
      render :new
    end
  end

  def manage
    @subscriber = Subscriber.find_by uuid: params['uuid']
  end

  def update
    @subscriber = Subscriber.find_by uuid: params['subscriber']['uuid']
    if @subscriber.update(subscriber_params)
      Subscription.where({subscriber_id: @subscriber}).destroy_all
      params['subscriber']['subscription_list_ids'].each do |s|
        new_subscription = SubscriptionList.where(id: s).take
        if new_subscription
          Subscription.create({subscriber_id: @subscriber.id,
                               subscription_list_id: new_subscription.id})
        end
      end
      redirect_to action: :manage, uuid: @subscriber.uuid
    else
      render :manage
    end
  end

  def delete
    @subscriber = Subscriber.find_by uuid: params['uuid']
  end

  def destroy
    @subscriber = Subscriber.find_by uuid: params['uuid']

    Subscription.where({subscriber_id: @subscriber}).destroy_all
    Syndication.where({subscriber_id: @subscriber}).destroy_all
    @subscriber.destroy

    redirect_to :deleted
  end

  def deleted
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(
      :email,
      :first_name,
      :last_name
    )
  end
end
