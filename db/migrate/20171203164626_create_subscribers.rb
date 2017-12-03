class CreateSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribers do |t|
      t.string :email, null: false
      t.boolean :confirmed, null: false
      t.string :hash, null: false

      t.index :email, unique: true

      t.timestamps
    end
  end
end
