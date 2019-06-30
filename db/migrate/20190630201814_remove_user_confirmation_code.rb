class RemoveUserConfirmationCode < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :registration_confirmation_code
  end
end
