class Event < ApplicationRecord
  belongs_to :subscription_list

  has_many :users, through: :syndications
  has_many :rsvps

  validate :check_attendance_below_limit
  validate :check_end_after_start
  validates :datetime, presence: true, uniqueness: true
  validates :datetime_end, presence: true
  validates :description, presence: true
  validates :address_id, presence: true

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
      e.location    = Address.find(address_id).formatted_full_one_line
      e.organizer   = "mailto:#{ENV.fetch('EVENT_ORGANIZER_USER')}@#{ENV.fetch('EMAIL_DOMAIN')}"
      e.description = description
    end

    # Using 'REQUEST' means that when the recipient selects a response it will
    # get emailed back to the organizer email address. Make sure that address
    # can receive mail or else the user will get a bounceback. If you don't
    # want this behavior, you can change the method to 'PUBLISH'. Email clients
    # will add an "Add this event to your calendar" button instead of
    # "Yes/No/Maybe" RSVP buttons
    cal.ip_method = 'REQUEST'
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
