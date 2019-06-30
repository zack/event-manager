class UserConfirmed < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_confirmed, :boolean
  end
end
