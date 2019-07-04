class AdminController < ApplicationController
  before_action :validate_session, except: [:login, :process_login]

  def index
  end

  def login
  end

  def logout
    session[:admin] = nil
    flash[:success] = 'You have successfully logged out'
    redirect_to :admin_login
  end

  def process_login
    if params[:password] === ENV.fetch('ADMIN_PASSWORD')
      session[:admin] = Time.now.to_i
      flash[:success] = 'You have successfully logged in'
      redirect_to :admin_index
    else
      flash[:warning] = 'Bad Password'
      render :login
    end
  end

  def users
    @users = User.all
  end

  def user
    @user = User.find_by(uuid: params[:uuid])
    @subscriptions = Subscription.where(user_id: @user).map do |s|
      SubscriptionList.find(s.subscription_list_id).name
    end
  end

  def confirm_user
    @user = User.find_by(uuid: params[:uuid])
    @user.update(admin_confirmed: true)
    flash[:success] = 'User successfully confirmed'
    redirect_to :admin_view_user
  end

  def delete_user
    @user = User.find_by uuid: params['uuid']
    destroy_user(@user)
  end

  def destroy_user(user)
    Subscription.where(user_id: @user).destroy_all
    Syndication.where(user_id: @user).destroy_all
    flash[:success] = "Successfully deleted #{user.name()}"
    @user.destroy

    redirect_to :admin_view_users
  end

  private

    def validate_session
      if not session[:admin]
        flash[:warning] = 'You must be logged in'
        redirect_to :admin_login
      end
    end
end
