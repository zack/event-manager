class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :subscription_list, null: false

      t.integer :capacity
      t.text :description, null: false
      t.datetime :datetime, null: false

      t.index :datetime, unique: true

      t.timestamps
    end
  end
end
