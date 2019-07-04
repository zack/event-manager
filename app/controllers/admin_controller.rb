class AdminController < ApplicationController
  before_action :require_admin_login, except: [:login, :process_login]

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
end
