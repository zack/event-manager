class AddEmailChangeConfirmationCode < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_change_confirmation_code, :string
  end
end
