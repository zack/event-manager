class AddInviteTypeToUserModel < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :invitation_type, :integer
    change_column_null :users, :invitation_type, false
  end
end
