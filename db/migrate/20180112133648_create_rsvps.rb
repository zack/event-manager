class CreateRsvps < ActiveRecord::Migration[5.1]
  def change
    create_table :rsvps do |t|
      t.references :event, null: false
      t.references :user, null: false

      t.integer :response

      t.timestamps
    end
  end
end
