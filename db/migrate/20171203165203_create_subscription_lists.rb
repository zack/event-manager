class CreateSubscriptionLists < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_lists do |t|
      t.string :name, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
