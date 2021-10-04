class RemoveGcalIdFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :gcal_event_id, :string
  end
end
