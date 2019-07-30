class AddDeletedColumnToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :deleted, :boolean
  end
end
