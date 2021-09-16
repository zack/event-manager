class Location < ApplicationRecord
  validates_presence_of :address_line_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip

  def formatted_full
    '${address_line_1}'
    '${address_line_2}'
    '${city}, ${state} ${zip}'
  end
end
