class RemoveAddressRequirementOnEvents < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :address_id, true
  end
end
