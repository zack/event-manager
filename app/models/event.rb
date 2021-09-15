class Event < ApplicationRecord
  belongs_to :subscription_list

  has_many :users, through: :syndications
  has_many :rsvps

  validate :check_attendance_below_limit
  validate :check_end_after_start
  validates :datetime, presence: true, uniqueness: true
  validates :datetime_end, presence: true
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

  def create_ics(attendee)
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = datetime.utc.strftime('%Y%m%dT%H%M%SZ')
      e.dtend       = datetime_end.utc.strftime('%Y%m%dT%H%M%SZ')
      e.attendee    = "mailto:#{attendee.email_address}"
      e.summary     = subscription_list.name
      e.location    = location
      e.organizer   = "mailto:#{ENV.fetch('EMAIL_USER')}@#{ENV.fetch('EMAIL_DOMAIN')}"
      e.description = description
    end

    cal.ip_method = 'PUBLISH'
    cal.to_ical
  end

  private

  def check_attendance_below_limit
    if capacity && attendees >= capacity
      errors.add(:capacity, 'has been reached!')
    end
  end

  def check_end_after_start
    if datetime_end < datetime
      errors.add(:datetime_end, 'is before start')
    end
  end
end
