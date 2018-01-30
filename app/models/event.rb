class Event < ApplicationRecord
  belongs_to :subscription_list

  has_many :users, through: :syndications
  has_many :rsvps

  validate :check_attendance_below_limit
  validates :capacity, presence: true
  validates :datetime, presence: true,
                       uniqueness: true
  validates :description, presence: true

  def attendees
    Rsvp.where({ event_id: id, response: true})
  end

  private

  def check_attendance_below_limit
    if attendees.count >= capacity
      errors.add(:capacity, "has been reached!")
    end
  end
end
