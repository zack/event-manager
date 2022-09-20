class RenameSpecialEventSyndications < ActiveRecord::Migration[7.0]
  def change
    rename_table('special_event_syndications', 'special_event_guests')
  end
end
