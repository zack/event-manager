class AddBackupEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_backup, :string
  end
end
