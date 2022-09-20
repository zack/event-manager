class AddInvitedToSpecialEventSyndications < ActiveRecord::Migration[7.0]
  def change
    add_column :special_event_syndications, :invited, :boolean
    change_column_null :special_event_syndications, :invited, false, false
  end
end
