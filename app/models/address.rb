class Address < ApplicationRecord
  validates_presence_of :address_line_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip

  def formatted_full_one_line
    if address_line_2.length > 0
      "#{address_line_1}, #{address_line_2}, #{city}, #{state} #{zip}"
    else
      "#{address_line_1}, #{city}, #{state} #{zip}"
    end
  end

  def is_deleteable
    true
  end
end
