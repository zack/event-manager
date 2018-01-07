class UpdateSubscriberConfirmations < ActiveRecord::Migration[5.1]
  def change
    rename_column :subscribers, :confirmed, :email_confirmed

    # Creating a non-nullable column requires specifying a default
    # value, but updating an existing column to not-null does not.
    #
    add_column :subscribers, :admin_confirmed, :boolean
    change_column_null :subscribers, :admin_confirmed, false

    add_column :subscribers, :email_confirmation_code, :string
    change_column_null :subscribers, :admin_confirmed, false
  end
end
