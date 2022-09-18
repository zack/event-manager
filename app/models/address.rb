class Address < ApplicationRecord
  validates_presence_of :address_line_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip

  belongs_to :event, optional: true

  def formatted_full_one_line
    if address_line_2 && address_line_2.length > 0
      "#{address_line_1}, #{address_line_2}, #{city}, #{state} #{zip}"
    else
      "#{address_line_1}, #{city}, #{state} #{zip}"
    end
  end

  def google_maps_link
    url_base = 'https://www.google.com/maps/place/'
    address = "#{address_line_1}+#{city}+#{state}+#{zip}"

    "#{url_base}#{address}"
  end
end
