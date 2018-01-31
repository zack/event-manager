class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.uuid = SecureRandom.uuid
    @user.email_confirmed = false
    @user.admin_confirmed = false
    @user.email_confirmation_code = SecureRandom.hex

    if @user.save
      params['user']['subscription_list_ids'].each do |s|
        new_subscription = SubscriptionList.where(id: s).take
        if new_subscription
          Subscription.create(user_id: @user.id,
                               subscription_list_id: new_subscription.id)
        end
      end

      UserMailer.confirmation_email(@user).deliver_now

      redirect_to action: :edit, uuid: @user.uuid
    else
      @user.uuid = nil
      render :new
    end
  end

  def edit
    @user = User.find_by uuid: params['uuid']
  end

  def update
    @user = User.find_by uuid: params['user']['uuid']
    if @user.update(user_params)
      Subscription.where(user_id: @user).destroy_all
      params['user']['subscription_list_ids'].each do |s|
        new_subscription = SubscriptionList.where(id: s).take
        if new_subscription
          Subscription.create(user_id: @user.id,
                               subscription_list_id: new_subscription.id)
        end
      end
      flash[:success] = 'Profile successfully updated!'
      redirect_to action: :edit, uuid: @user.uuid
    else
      render :edit
    end
  end

  def delete
    @user = User.find_by uuid: params['uuid']
  end

  def destroy
    @user = User.find_by uuid: params['uuid']

    Subscription.where(user_id: @user).destroy_all
    Syndication.where(user_id: @user).destroy_all
    @user.destroy

    redirect_to :deleted
  end

  def deleted
  end

  def confirm_email
    @user = User.find_by uuid: params['uuid']
    @confirmation_code = params['code']
    if @user && (@user.email_confirmation_code == @confirmation_code)
      @user.update(email_confirmed: true)
      flash[:success] = 'Email confirmed!'
      redirect_to action: :edit, uuid: @user.uuid
    else
      render :email_not_confirmed
    end
  end

  def resend_confirmation
    @user = User.find_by uuid: params['uuid']
    UserMailer.confirmation_email(@user).deliver_now
    flash[:success] = 'Sent!'
    redirect_to action: :edit, uuid: @user.uuid
  end

  private

    def user_params
      params.require(:user).permit(
        :email_address,
        :first_name,
        :last_name
      )
    end
end
