class UpdateUserConfirmations < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :confirmed, :email_confirmed

    # Creating a non-nullable column requires specifying a default
    # value, but updating an existing column to not-null does not.
    #
    add_column :users, :admin_confirmed, :boolean
    change_column_null :users, :admin_confirmed, false

    add_column :users, :email_confirmation_code, :string
    change_column_null :users, :admin_confirmed, false
  end
end
