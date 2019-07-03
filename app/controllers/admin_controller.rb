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

  private

    def validate_session
      if not session[:admin]
        flash[:warning] = 'You must be logged in'
        redirect_to :admin_login
      end
    end
end
