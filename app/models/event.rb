class Event < ApplicationRecord
  belongs_to :subscription_list

  has_many :users, through: :syndications
  has_many :rsvps

  validate :check_attendance_below_limit
  validates :datetime, presence: true,
                       uniqueness: true
  validates :description, presence: true

  def attendees
    Rsvp.where(event_id: id).where('response > ?', 0).pluck(:response).reduce(:+) || 0
  end

  def maybes
    Rsvp.where(event_id: id).where('response = ?', 0).count || 0
  end

  def nopes
    Rsvp.where(event_id: id).where('response = ?', -1).count || 0
  end

  private

    def check_attendance_below_limit
      if capacity && attendees >= capacity
        errors.add(:capacity, 'has been reached!')
      end
    end
end
