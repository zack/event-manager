class RenameEmailChangeConfirmationCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :email_change_confirmation_code, :email_confirmation_code
  end
end
