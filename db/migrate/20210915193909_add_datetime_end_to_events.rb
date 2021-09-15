class AddDatetimeEndToEvents < ActiveRecord::Migration[6.1]
  def change
    # Creating a non-nullable column requires specifying a default
    # value, but updating an existing column to not-null does not.
    #
    add_column :events, :datetime_end, :datetime
    change_column_null :events, :datetime_end, false
  end
end
