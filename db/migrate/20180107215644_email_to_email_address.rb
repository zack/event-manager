class EmailToEmailAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :email, :email_address
  end
end
