class RemoveCapacityFromSpecialEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column(:special_events, :capacity)
  end
end
