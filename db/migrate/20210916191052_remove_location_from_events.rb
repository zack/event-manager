class RemoveLocationFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :location, :string
  end
end
