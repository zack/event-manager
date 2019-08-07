class AddGcalEventIdToEvent < ActiveRecord::Migration[5.1]
  def change
    # Creating a non-nullable column requires specifying a default
    # value, but updating an existing column to not-null does not.
    #
    add_column :events, :gcal_event_id, :string
  end
end
