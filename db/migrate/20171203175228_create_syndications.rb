class CreateSyndications < ActiveRecord::Migration[5.1]
  def change
    create_table :syndications do |t|
      t.references :event_id, null: false
      t.references :subscriber_id, null: false

      t.timestamps
    end
  end
end
