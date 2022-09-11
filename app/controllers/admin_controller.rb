class AdminController < ApplicationController
  before_action :require_admin_login, except: [:login, :process_login]

  def index
    @events = Event.where('datetime_end > ?', DateTime.now).where(deleted: nil).order(datetime: :asc)
  end

  def test_exception
    # make sure exception emails are working on production
    raise 'exception'
  end

  def compose_email
  end

  def send_email
    subject = params[:email][:subject]
    body = params[:email][:body]
    target = params[:email][:subscription_list_id]

    if [subject, body, target].include?(nil)
      redirect_to :admin_compose_email
    end

    # If target is -1, get all users. Otherwise, get users subscribed to given list id
    @users = target == '-1' ?
      User.all :
      User.includes(:subscription_lists).where(subscription_lists: { id: target })

    @users.each do |u|
      UserMailer.ad_hoc_send(u, subject, body).deliver_now
    end

    flash[:success] = "Sent to #{@users.count} users!"
    redirect_to :admin_compose_email
  end

  def login
    if session[:admin]
      redirect_to :admin_index
    elsif cookies['remember_me'] && (BCrypt::Password.new(cookies['remember_me']) == ENV.fetch('ADMIN_PASSWORD'))
      session[:admin] = Time.now.to_i
      flash.discard
      redirect_to :admin_index
    end
  end

  def logout
    session[:admin] = nil
    cookies.delete  :remember_me
    flash[:success] = 'You have successfully logged out'
    redirect_to :admin_login
  end

  def process_login
    if params[:password] === ENV.fetch('ADMIN_PASSWORD')

      value = BCrypt::Password.create(ENV.fetch('ADMIN_PASSWORD'))
      cookies['remember_me'] = { value: value, expires: 30.days.from_now }

      session[:admin] = Time.now.to_i
      flash[:success] = 'You have successfully logged in'
      redirect_to :admin_index
    else
      flash[:warning] = 'Bad Password'
      render :login
    end
  end
end
