class AdminController < ApplicationController
  def index
    if not session[:admin]
      redirect_to :admin_login
    end
  end

  def login
  end

  def logout
    session[:admin] = nil
    redirect_to :admin_index
  end

  def process_login
    if params[:password] === ENV.fetch('ADMIN_PASSWORD')
      session[:admin] = Time.now.to_i
      redirect_to :admin_index
    else
      flash[:warning] = 'Bad Password'
      render :login
    end
  end

  def users
    @users = User.all
  end
end
