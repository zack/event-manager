class CreateRsvps < ActiveRecord::Migration[5.1]
  def change
    create_table :rsvps do |t|
      t.references :event, null: false
      t.references :subscriber, null: false

      t.boolean :response

      t.timestamps
    end
  end
end
