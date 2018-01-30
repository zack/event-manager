class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false
      t.references :subscription_list, null: false

      t.index [:user_id, :subscription_list_id], unique: true

      t.timestamps
    end
  end
end
