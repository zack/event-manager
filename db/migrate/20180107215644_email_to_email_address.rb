class EmailToEmailAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :subscribers, :email, :email_address
  end
end
