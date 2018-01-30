class CreateSyndications < ActiveRecord::Migration[5.1]
  def change
    create_table :syndications do |t|
      t.references :event, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
