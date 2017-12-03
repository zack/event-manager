class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :subscription_list, null: false

      t.date :date, null: false
      t.text :description, null: false
      t.time :time, null: false

      t.index :date, unique: true

      t.timestamps
    end
  end
end
