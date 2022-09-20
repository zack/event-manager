class AddNameToSpecialEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :special_events, :name, :string, null: false
  end
end
