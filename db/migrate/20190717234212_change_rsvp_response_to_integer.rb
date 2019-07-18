class ChangeRsvpResponseToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :rsvps, :response, :integer
  end
end
