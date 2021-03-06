class UsersController < ApplicationController
  before_action :require_admin_login, only: [
    :index, :admin, :edit, :admin_delete, :admin_destroy, :confirm_user
  ]

  include Rails.application.routes.url_helpers

  def index
    @users = User.all.order(:first_name, :last_name)
  end

  def show
  end

  def admin
    @user = User.find_by(uuid: params[:uuid])
    @existing_invite_value = @user.invitation_type || false
    @subscriptions = Subscription.where(user_id: @user).map do |s|
      SubscriptionList.find(s.subscription_list_id).name
    end
  end

  def new
    @user = User.new
    @options_for_invite = User::INVITE_TYPE_BY_VALUE.map { |k, v| [v, k] }
    @existing_invite_value = @user.invitation_type || false
  end

  def create
    @user = User.new(user_params)
    @user.update(uuid: SecureRandom.uuid)
    @user.update(email_confirmed: false)
    @user.update(user_confirmed: false)
    @user.update(admin_confirmed: false)
    @user.update(email_confirmation_code: SecureRandom.hex)

    if @user.save
      params['user']['subscription_list_ids'].each do |s|
        new_subscription = SubscriptionList.where(id: s).take
        if new_subscription
          Subscription.create(user_id: @user.id,
                               subscription_list_id: new_subscription.id)
        end
      end

      send_user_confirmation_email(@user)

      return(redirect_to action: :show, uuid: @user.uuid)
    else
      @user.uuid = nil
      render :new
    end
  end

  def show
    @user = User.find_by uuid: params['uuid']
    @options_for_invite = User::INVITE_TYPE_BY_VALUE.map { |k, v| [v, k] }
    @existing_invite_value = @user.invitation_type || false
  end

  def update
    @user = User.find_by uuid: params['user']['uuid']
    request_email_update = params['user']['email_address'] != @user['email_address']

    if @user.update(user_params)
      Subscription.where(user_id: @user).destroy_all
      params['user']['subscription_list_ids'].each do |s|
        new_subscription = SubscriptionList.where(id: s).take
        if new_subscription
          Subscription.create(
            user_id: @user.id,
            subscription_list_id: new_subscription.id
          )
        end
      end

      if request_email_update
        @user.update(email_confirmation_code: SecureRandom.hex)
        @user.update(email_confirmed: false)
        if @user.save
          UserMailer.change_email_address_email(@user).deliver_now
        end
      end

      flash[:success] = 'Profile successfully updated!'
      return(redirect_to action: :show, uuid: @user.uuid)
    else
      render :show
    end
  end

  def delete
    @user = User.find_by uuid: params['uuid']
    destroy(@user)
  end

  def destroy(user, admin = false)
    Subscription.where(user_id: @user).destroy_all
    Syndication.where(user_id: @user).destroy_all
    Rsvp.where(user_id: @user).destroy_all
    @user.destroy

    if admin
      redirect_to :users
    else
      redirect_to :deleted_user
    end
  end

  def admin_delete
    @user = User.find_by uuid: params['uuid']
    destroy(@user, true)
  end

  def deleted
  end

  def confirm_user
    @user = User.find_by(uuid: params[:uuid])
    @user.update(admin_confirmed: true)
    flash[:success] = 'User successfully confirmed'
    redirect_to :admin_user
  end

  def confirm_email
    @user = User.find_by email_confirmation_code: params['code']
    if @user == nil
      return(redirect_to :email_already_confirmed)
    end
    @user.update(email_backup: nil)
    @user.update(email_confirmation_code: nil)
    @user.update(email_confirmed: true)
    @user.update(user_confirmed: true)

    if @user.save
      flash[:success] = 'Thank you, your email address has been confirmed!'
      if params['admin']
        flash[:success] = 'The user\'s email address has been succesfully confirmed.'
        return(redirect_to action: :admin, uuid: @user.uuid)
      else
        return(redirect_to action: :show, uuid: @user.uuid)
      end
    end
  end

  def revert_email
    @user = User.find_by email_confirmation_code: params['code']
    @user.update(email_address: @user.email_backup)
    @user.update(email_backup: nil)
    @user.update(email_confirmation_code: nil)
    if @user.save
      return(redirect_to :email_change_reverted)
    end
  end

  def recover_account_submit
    @user = User.find_by email_address: params['email_address']
    if @user
      UserMailer.recover_account(@user).deliver_now
    end
    render :recover_account_confirmation
  end

  def send_user_confirmation_email(user)
    UserMailer.confirmation_email(user).deliver_now
  end

  def resend_confirmation
    @user = User.find_by uuid: params['uuid']
    if @user.user_confirmed
      UserMailer.change_email_address_email(@user).deliver_now
    else
      send_user_confirmation_email(@user)
    end
    flash[:success] = 'Sent!'
    redirect_to action: :show, uuid: @user.uuid
  end

  private

    def user_params
      params.require(:user).permit(
        :email_address,
        :first_name,
        :invitation_type,
        :last_name
      )
    end
end
