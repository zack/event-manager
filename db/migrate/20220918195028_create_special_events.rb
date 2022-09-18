class CreateSpecialEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :special_events do |t|

      t.string :uuid
      t.integer :capacity
      t.references :address
      t.text :description, null: false
      t.datetime :datetime, null: false
      t.datetime :datetime_end, precision: nil
      t.boolean :deleted, null: false

      t.timestamps
    end
  end
end
