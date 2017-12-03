class CreateSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribers do |t|
      t.boolean :confirmed, null: false
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :uuid, null: false

      t.index :email, unique: true
      t.index :uuid, unique: true

      t.timestamps
    end
  end
end
