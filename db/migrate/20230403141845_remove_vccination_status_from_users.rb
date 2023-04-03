class RemoveVccinationStatusFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :vaccination_status, :integer
  end
end
