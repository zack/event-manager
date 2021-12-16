class AddVaccinationStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :vaccination_status, :integer
  end
end
