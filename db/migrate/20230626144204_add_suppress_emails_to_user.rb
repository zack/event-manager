class AddSuppressEmailsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :suppress_emails, :boolean
  end
end
