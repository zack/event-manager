class WelcomeController < ApplicationController
  def index
  end

  def test_invite
    @user = User.where({ email_address: 'zack127@gmail.com' }).take
    @event = Event.where({ uuid: '38ec92c6-5971-47af-bda3-3ed916d3ff90' }).take
    UserMailer.invite(@user, @event).deliver_now
    @user = User.where({ email_address: 'zack@youngren.io' }).take
    UserMailer.invite(@user, @event).deliver_now
  end
end
