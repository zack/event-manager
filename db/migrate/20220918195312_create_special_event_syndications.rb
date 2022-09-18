class CreateSpecialEventSyndications < ActiveRecord::Migration[7.0]
  def change
    create_table :special_event_syndications do |t|

      t.references :special_event, null: false

      t.string :email_address
      t.integer :rsvp

      t.timestamps
    end
  end
end
