class SpecialEvent < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one :address

  has_many :special_event_guests

  validate :check_end_after_start
  validates :datetime, presence: true, uniqueness: true
  validates :datetime_end, presence: true
  validates :name, presence: true
  validates :description, presence: true

  def added
    SpecialEventGuest.where({special_event_id: id}).count
  end

  def invited
    SpecialEventGuest.where({special_event_id: id, invited: true }).count
  end

  def coming
    SpecialEventGuest.where(special_event_id: id).where('rsvp > ?', 0).pluck(:rsvp).reduce(:+) || 0
  end

  def plus_ones
    coming - SpecialEventGuest.where(special_event_id: id).where('rsvp > ?', 0).count
  end

  def maybes
    SpecialEventGuest.where(special_event_id: id).where(rsvp: 0).count
  end

  def declined
    SpecialEventGuest.where(special_event_id: id).where(rsvp: -1).count
  end

  def unresponded
    SpecialEventGuest.where({special_event_id: id, rsvp: -2, invited: true}).count
  end

  def create_ics(guest)
    ics_description =
    <<~EOS
      #{ActionView::Base.full_sanitizer.sanitize(description)}
    EOS

    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = datetime.utc.strftime('%Y%m%dT%H%M%SZ')
      e.dtend       = datetime_end.utc.strftime('%Y%m%dT%H%M%SZ')
      e.attendee    = "mailto:#{guest.email_address}"
      e.summary     = name
      e.location    = Address.find(address_id).formatted_full_one_line
      e.organizer   = "mailto:#{ENV.fetch('SPECIAL_EMAIL_USER')}@#{ENV.fetch('SPECIAL_EMAIL_DOMAIN')}"
      e.description = ics_description
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

    def check_end_after_start
      if datetime_end < datetime
        errors.add(:datetime_end, 'is before start')
      end
    end
end
