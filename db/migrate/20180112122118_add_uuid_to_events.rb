class AddUuidToEvents < ActiveRecord::Migration[5.1]
  def change
    # Creating a non-nullable column requires specifying a default
    # value, but updating an existing column to not-null does not.
    #
    add_column :events, :uuid, :string
    change_column_null :events, :uuid, false
  end
end
