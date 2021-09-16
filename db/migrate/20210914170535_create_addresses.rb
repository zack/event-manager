class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.text :address_line_1, null: false
      t.text :address_line_2
      t.text :city, null: false
      t.text :state, null: false
      t.text :zip, null: false

      t.text :special_instructions
    end
  end
end
