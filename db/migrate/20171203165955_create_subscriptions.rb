class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, null: false
      t.references :subscription_list, null: false

      t.index [:subscriber_id, :subscription_list_id], unique: true

      t.timestamps
    end
  end
end
