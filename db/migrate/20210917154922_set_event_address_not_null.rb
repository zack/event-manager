class SetEventAddressNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :address_id, false
  end
end
