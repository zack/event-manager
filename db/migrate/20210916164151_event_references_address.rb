class EventReferencesAddress < ActiveRecord::Migration[6.1]
  def change
    change_table :events do |t|
      t.references :address
    end
  end
end
