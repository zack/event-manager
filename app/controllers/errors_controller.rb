class ErrorsController < ApplicationController
  def email_already_confirmed
    render :email_already_confirmed
  end
end
