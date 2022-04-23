class AddressesController < ApplicationController
  before_action :require_admin_login, only: [
    :index, :new, :create, :edit, :update, # :delete, :destroy
  ]

  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to action: :index
    else
      @address.id = nil
      render :new
    end
  end

  def edit
    @address = Address.find_by id: params['id']
  end

  def update
    @address = Address.find_by id: params['address']['id']

    old_address = @address.clone
    @address.assign_attributes(address_params)
    address_changed = @address.changed?

    if address_changed
      flash[:success] = 'Address successfully updated!'
    else
      flash[:notice] = 'No changes detected.'
    end

    if @address.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def delete
    address_id = params[:id]
    @address = Address.find_by id: address_id
    @future_event_count = Event.where({ address_id: address_id }).filter { |e| e.datetime > DateTime.now }.count
    @past_event_count = Event.where({ address_id: address_id }).filter { |e| e.datetime < DateTime.now }.count
  end

  def destroy
    address_id = params[:id]

    @address = Address.find_by id: address_id
    @address.delete
    events = Event.where({ address_id: address_id })
    events.each do |e|
      e.update(address_id: nil)
    end
    flash[:success] = "Successfully deleted: #{@address.address_line_1}!"
    redirect_to action: :index
  end

  private

    def address_params
      params.require(:address).permit(
        :address_line_1,
        :address_line_2,
        :city,
        :special_instructions,
        :state,
        :zip
      )
    end
end
